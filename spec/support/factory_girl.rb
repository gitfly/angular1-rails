RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # config.before(:suite) do
  #   begin
  #     DatabaseCleaner.strategy = :truncation
  #     # FactoryGirl.lint
  #   ensure
  #     DatabaseCleaner.clean
  #   end
  # end

end
