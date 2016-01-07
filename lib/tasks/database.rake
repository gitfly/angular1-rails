namespace :database do
  desc "Dump database"
  task :dump, [:interval] => :environment do |task, args|
    password = Rails.configuration.database_configuration["production"]['password']
    system "mysqldump -u root -p#{password} baozheng > /home/deploy/baozheng/datas/baozheng_#{args.interval}.sql"
  end

  desc "Dump Category data"
  task :dump_category => :environment do
    cats = Category.where(name: %W(手提包 单肩包 双肩包 钥匙包), depth: 0)
    FirstCat = Category.where(name: "钱包", depth: 0).first

    def search_category(cat, target)
      target.children.each do |c|
        cc = cat.children.create!(name: c.name)
        search_category(cc, c)
      end
    end

    cats.each do |cc|
      search_category(cc, FirstCat)
    end
  end

  desc "Parse old data of photoDesc"
  task :parse_photo_desc=> :environment do
    photoDescs = PhotoDesc.all
    can_parse_counter = not_parse_counter = 0 
    photoDescs.each do |p|
      content = p.content
      if content && match = content.match(/^症状[：|:](.*)工艺[：|:](.*)预期效果[：|:](.*)$/m)
        p.symptom, p.technology, p.expect = match.captures
        p.content = "<span class='highlighted-desc font-size14'>症状：</span>#{p.symptom} <span class='highlighted-desc font-size14'>工艺：</span>#{p.technology} <span class='highlighted-desc font-size14'>预期效果：</span>#{p.expect}"
        PhotoDesc.update(p.id, :content => p.content, :symptom => p.symptom, :technology => p.technology, :expect => p.expect)
        can_parse_counter = can_parse_counter + 1
        next
      elsif content && match = content.match(/^症状[：|:](.*)工艺[：|:](.*)$/m)
        p.symptom, p.technology = match.captures
        p.content = "<span class='highlighted-desc font-size14'>症状：</span>#{p.symptom} <span class='highlighted-desc font-size14'>工艺：</span>#{p.technology}"
        PhotoDesc.update(p.id, :content => p.content, :symptom => p.symptom, :technology => p.technology)
        can_parse_counter = can_parse_counter + 1
        next
      elsif content && match = content.match(/^工艺[：|:](.*)预期效果[：|:](.*)$/m)
        p.technology, p.expect = match.captures
        p.content = "<span class='highlighted-desc font-size14'>工艺：</span>#{p.technology} <span class='highlighted-desc font-size14'>预期效果：</span>#{p.expect}" 
        PhotoDesc.update(p.id, :content => p.content, :technology => p.technology, :expect => p.expect)
        can_parse_counter = can_parse_counter + 1
        next 
      elsif !p.technology
        PhotoDesc.update(p.id, :symptom => p.content)
        not_parse_counter = not_parse_counter + 1
      end   
    
    end
    puts "there are #{can_parse_counter} items parsed"
    puts "there are #{not_parse_counter} items can not parse" 
  end

  desc "import User data"
  task :import_user => :environment do
      save_counter = counter = 0
      File.delete('tmp/member.txt')
      File.open("tmp/member_history.txt", "r") do |infile|
         while (line = infile.gets)
            line_split = line.split(' ')
            user_of_database = Customer.find_by(phone: line_split[0])
            if user_of_database
             balance_of_file = line_split[2].delete(",")
             balance_of_file.slice!(0)
             if user_of_database.balance.to_i != balance_of_file.to_i
                begin
                  counter = counter + 1
                  file = File.open("tmp/member.txt", "a") do |f|
                    f << "#{counter} #{user_of_database.phone}  #{user_of_database.name}  #{user_of_database.balance} 导入数据中余额：#{balance_of_file.to_i}\n"
                  end
                end
             end
            else
               balance = line_split[2]
               balance.slice!(0)
               Customer.create(
               phone: line_split[0],
               name: line_split[1],
               balance: balance.to_i,
               email: "#{line_split[0]}@baozheng.cc",
               is_member: balance.to_i != 0 ? 1 : 0,
               password: SecureRandom.hex(4),
               type: "Customer",
               created_at: line_split[3]
               )
               save_counter = save_counter + 1
            end 
         end
      end
      puts "there are #{counter} items different from the file"
      puts "there are #{save_counter} items saved in databases"     
  end

  desc "update order status"
  task :update_order_status => :environment do

    status_hash = {
      0 => "advance_order" ,
      1 => "waiting_for_pickup",
      2 => "finish_pickup",
      3 => "into_storage",
      4 => "upload_photo",
      5 => "diagnose",
      6 => "blue_print",
      7 => "verify_order",
      8 => "send_to_factory",
      9 => "factory_receive",
      10 => "producing",
      11 => "finish_product",
      12 => "store_receive",
      13 => "quality_testing",
      14 => "effect_photo",
      15 => "effect_result",
      16 => "delivery",
      17 => "finish_delivery",
      18 => "complete"
    }

    File.open('/tmp/order_info.txt', 'w') do |f|

      Order.find_in_batches do |orders|
        orders.each do |order|
          begin
            status_des = status_hash[order.status]
            order.update!(status: ::OrderStatus::Status[status_des.to_sym])
          rescue Exception => e
            f.puts "#{order.id}: #{e.message}"
          end
        end
      end

      f.puts "-----------------------------------------------------------"

      OrderStatus.find_in_batches do |statuses|
        statuses.each do |status|
          begin
            status_des = status_hash[status.status]
            status.update!(status: ::OrderStatus::Status[status_des.to_sym])
          rescue Exception => e
            f.puts "#{status.id}: #{e.message}"
          end
        end
      end
      
    end

  end


  desc "import customer balance"
  task :import_balance => :environment do
      update_counter = counter = 0
      File.open("tmp/balance.txt", "r") do |infile|
          while (line = infile.gets)
            line_split = line.split(' ')
            customer_of_database = Customer.with_deleted.find_by(phone: line_split[0])
            if customer_of_database 
              if customer_of_database.deleted?
                file = File.open("tmp/customer_can_not_find.txt", "a") do |f|
                  f << "has deleted : #{line}"
                end
              else
                balance_of_file = line_split[2].to_f
                discount_of_file = line_split[3].to_f/100
                customer_of_database.update_attributes!(
                  discount: discount_of_file,
                  balance: balance_of_file
                )
                update_counter += 1
              end   
            else
                begin

                  file = File.open("tmp/customer_can_not_find.txt", "a") do |f|
                    f << "#{line}"
                  end
                  balance = line_split[2]
                  balance.slice!(0)
                  Customer.create(
                   phone: line_split[0],
                   name: line_split[1],
                   balance: balance.to_i,
                   discount: line_split[3].to_f/100,
                   email: "#{line_split[0]}@baozheng.cc",
                   is_member: balance.to_i != 0 ? 1 : 0,
                   password: SecureRandom.hex(4),
                   type: "Customer",
                   created_at: line_split[4]
                  )
                end
                counter += 1
            end 
          end
      end
      puts "there are #{counter} items can not find from databases"
      puts "there are #{update_counter} items updated"  
  end

  desc "change date_detail to hour_start and hour_start"
  task :order_date_detail => :environment do
    def fetch_hour_start(order)
      order.fetch_date_detail or return nil
      val = order.fetch_date_detail.split("-").first
      (val == 'undefined' || val=='null') and return nil
      val
    end

    def fetch_hour_end(order)
      order.fetch_date_detail or return nil
      val = order.fetch_date_detail.split("-")[1]
      if val
        val = val.split('|').first
        (val == 'undefined' || val=='null') and return nil
        val
      else
        nil
      end
    end

    def delivery_hour_start(order)
      order.delivery_date_detail or return nil
      val = order.delivery_date_detail.split("-").first
      (val == 'undefined' || val=='null') and return nil
      val
    end

    def delivery_hour_end(order)
      order.delivery_date_detail or return nil
      val = order.delivery_date_detail.split("-")[1]
      if val
        val = val.split('|').first
        (val == 'undefined' || val=='null') and return nil
        val
      else
        nil
      end
    end

    begin
      Order.find_in_batches do |orders|
        orders.each do |order|
          puts order.id
          order.fetch_hour_start = fetch_hour_start(order)
          order.fetch_hour_end = fetch_hour_end(order)
          order.delivery_hour_start = delivery_hour_start(order)
          order.delivery_hour_end = delivery_hour_end(order)
          order.save!(validate: false)
        end
      end
    rescue Exception => e
      puts e.message
    end
  end

  desc "reset order activity codes count"
  task :reset_order_activity_codes_count => :environment do
    ActivityCode.group('order_id').count.each do |oid, count|
      order = Order.where(id: oid).first
      puts '-'*50
      puts [oid, count, order.try(:id)]
      puts '-'*50
      order and Order.reset_counters oid, :activity_codes
    end
  end

  desc "update order status"
  task :use_new_order_status => :environment do
    OldStatus = {
      all: -1, 
      waiting_for_pickup: 0, # 待取货
      finish_pickup: 1, #取货完成
      advance_order: 2 , # 已开单
      send_to_factory: 3, # 送去修复中心
      factory_receive: 4, # 修复中心确认接收 
      adviser_sort_out: 5, #顾问分拣
      upload_photo: 6, #拍照
      diagnose: 7, #顾问诊断  
      blue_print: 8, #方案
      verify_order: 9, #订单确认
      attach_into_storage: 10 , #附件入库
      factory_sort_out: 11, # 修复分拣
      producing: 12, #修复中
      quality_testing: 13, #质检
      finish_product: 14 , #修复完成
      blue_print_testing: 15 , #方案质检
      effect_photo: 16, #效果拍照
      effect_result: 17, #效果方案
      into_storage: 18, #入库包装

      out_of_storage: 19, #出库
      store_receive: 20 , #门店接收
      delivery: 21, #派送 
      finish_delivery: 22, #派送完成
      complete: 23, #订单结束 
    }

    NewToOld = {
      0 =>  [0], 
      1 =>  [1, 2],
      2 =>  [3], 
      3 =>  [4], 
      4 =>  [5],
      5 =>  [7], 
      6 =>  [6],
      7 =>  [8],
      9 =>  [9], 
      10 => [10], 
      11 => [11, 12, 13], 
      12 => [14], 
      13 => [15], 
      14 => [16], 
      17 => [17],
      18 => [18], 
      21 => [19, 20, 21],
      22 => [22, 23]
    }

    NewToOld.each do |k, v|
      Order.where(status: v).update_all(status: k)
      OrderStatus.where(status: v).update_all(status: k)
    end
    Order.where(status: 0).where.not(pickup_manner: 1).update_all(status: 1)
  end

  desc "set ttype of worker"
  task :init_worker_ttype => :environment do
    unsaved_worder = {
      "李方": "lifang@baozheng.cc",
      "刘丽丽": "liulili@baozheng.cc",
      "张国宇": "zhangguoyu@baozheng.cc"
    }
    
    unsaved_worder.each do |k, v|
      User.create!(
        name: k,
        email: v, 
        password: "Baozheng123", 
        password_confirmation: "Baozheng123",
        type: "Worker"
      )
      puts "created new worker #{k}"
    end

    User.where(type: "Counselor", name: "李海丽").first.update_attributes(type: "Worker")
    puts "updated 李海丽 type Counselor -> Worker "

    worker_ttype = {
      "liuhua@baozheng.cc": "缝补",
      "lifang@baozheng.cc": "缝补",
      "liulili@baozheng.cc": "缝补",
      "liqing@baozheng.cc": "缝补",
      "wangbo@baozheng.cc": "边油",
      "fanli@baozheng.cc": "边油",
      "zhiping@baozheng.cc": "清洗",
      "haili@baozheng.cc": "清洗",
      "wangjun@baozheng.cc": "上色",
      "xiaodong@baozheng.cc": "上色",
      "weining@baozheng.cc": "上色",
      "qizhi@baozheng.cc": "上色",
      "zhangguoyu@baozheng.cc": "上色",
      "houfu@baozheng.cc": "上色"
    }

    worker_ttype.each do |k, v|
      user = User.where(type: "Worker", email: k).first
      if user
        user.update_attributes!(ttype: ::Technology::TType[v.to_sym])
        puts "set #{k} ttype -> #{v} finished!"
      else
        puts "can not find worker -> #{k}!"
      end
    end
  end


  # 08-06
  desc "migrate customer source data"
  task :migrate_customer_source => :environment do
    Customer::Source.each do |k, v|
      Customer.where(source: k).update_all(source: v)
    end
  end

  desc "set status updated at for orders"
  task :migrate_status_updated_at => :environment do
    Order.find_in_batches do |orders|
      orders.each do |o|
        puts o.id
        o.status_updated_at = (o.statuses.last||o).created_at
        o.save!(validate: false)
      end
    end
  end
  

end
