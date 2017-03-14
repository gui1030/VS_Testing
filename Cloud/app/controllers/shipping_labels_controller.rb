class ShippingLabelsController < ApplicationController
  def create
    @order = Order.find params[:order_id]
    authorize @order, :fulfillment?

    ups = ActiveShipping::UPS.new(
      login: Figaro.env.ups_login,
      password: Figaro.env.ups_password,
      key: Figaro.env.ups_key,
      origin_account: Figaro.env.ups_account,
      test: Figaro.env.test_shipping
    )

    origin = ActiveShipping::Location.new(
      address_type: :commercial,
      company_name: 'VeriSolutions, LLC',
      address1: '75 5th Street',
      address2: 'Suite 2180',
      city: 'Atlanta',
      state: 'GA',
      zip: '30308',
      country: 'US'
    )

    destination = ActiveShipping::Location.new(params[:destination])

    package = ActiveShipping::Package.new(params[:package][:weight].to_f, nil, units: :imperial)

    response = ups.create_shipment(origin, destination, package)

    @label = response.labels.first
  end
end
