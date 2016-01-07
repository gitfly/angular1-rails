module API
  module V1
    class Root < Grape::API

      before do
        # kclass = options[:for].name.split('::').last.singularize.constantize
        # method = options[:method].first.upcase
        # @action = if method == "GET"
        #            :read
        #          elsif %W(PUT POST DELETE).include?(method)
        #            :manage
        #          end
        # if params[:id]
        #   @object = kclass.find(params[:id])
        # else
        #   @object = kclass
        # end

      end

      use API::V1::ApiLogger if Rails.env.development?

      version 'v1', using: :path, vendor: 'baozheng'

      # mount API::V1::Reconciliations
      mount API::V1::Orders
      mount API::V1::Users
      mount API::V1::Customers
      mount API::V1::ConsumptionRecords
      mount API::V1::Services
      mount API::V1::OrderStatus
      mount API::V1::Addresses
      mount API::V1::Friends
      mount API::V1::Photos
      mount API::V1::Categories
      mount API::V1::OrderLogs
      mount API::V1::Items
      mount API::V1::Activities
      mount API::V1::Recharges
      mount API::V1::PhotoSymptoms
      mount API::V1::PhotoDescs
      mount API::V1::Descs
      mount API::V1::SoluTemplates
      mount API::V1::DescTags
      mount API::V1::Datareports
      mount API::V1::Settlements
      mount API::V1::Technologies
      mount API::V1::QualityTestings
      mount API::V1::Warehouses
      mount API::V1::Appointments
      mount API::V1::Couriers
      mount API::V1::FetchDelivery
    end
  end
end

