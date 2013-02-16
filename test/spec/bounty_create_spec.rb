require "spec_helper"

describe "Bounty Creation" do
  specify do
    @browser.goto "#"

    # find a bounty card and click on it
    bounty_card = nil
    @browser.div(class: 'card').wait_until_present

    # search through all cards until a bounty card is found
    @browser.divs(class: 'card').each do |e|
      if e.text =~ /Back this!/i
        bounty_card = e
        break
      end
    end

    bounty_card.should_not be_nil
    bounty_card.click

    # fill in bounty amount, select paypal and submit bounty create
    bounty_input = @browser.input(id: 'amount-input')
    bounty_input.wait_until_present
    @browser.radio(id: 'payment_method_paypal').click
    bounty_input.send_keys 25
    @browser.button(value: 'Create Bounty').click

    # go through paypal flow
    proceed_through_paypal_sandbox_flow!

    form = @browser.section(id: 'content').form
    form.wait_until_present
    form.text_field(name: 'email').set(CREDENTIALS["bountysource"]['email'])
    form.button.focus
    form.div(text: /Email address found/).wait_until_present
    form.text_field(name: 'password').set(CREDENTIALS["bountysource"]['password'])
    form.button.click

    @browser.h2(text: /\$\d+\s+bounty\s+placed/i).wait_until_present
  end
end