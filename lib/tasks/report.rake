namespace :report do
  desc "Send report_home datas by email"
  task :send_email => :environment do
    @contents = Order.packaging_data
    ReportHomeMailer.confirm(@contents).deliver
  end
end
