class ReportHomeMailer < ActionMailer::Base
  default from: 'javaBean_ym@163.com'

  def confirm(contents)
    mails = %W(
      yaoyao@baozheng.cc
      gujin@baozheng.cc
      yangyang@baozheng.cc
      weiwei@baozheng.cc
      zhenli@baozheng.cc
      xiaobao@baozheng.cc
      yunliang@baozheng.cc
      xiaobai@baozheng.cc
      zijia@baozheng.cc 
      fenglei@baozheng.cc 
      kelly@baozheng.cc
    )

    @contents = contents
    mail(to: mails, subject: "报表_#{Time.zone.now.strftime("%Y-%m-%d")}")
  end

end
