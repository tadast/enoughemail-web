require "application_system_test_case"

class FilterListsTest < ApplicationSystemTestCase
  setup do
    @filter_list = filter_lists(:one)
  end

  test "visiting the index" do
    visit filter_lists_url
    assert_selector "h1", text: "Filter Lists"
  end

  test "should create filter list" do
    visit filter_lists_url
    click_on "New filter list"

    fill_in "Description", with: @filter_list.description
    fill_in "Email pattern", with: @filter_list.email_pattern
    fill_in "Name", with: @filter_list.name
    click_on "Create Filter list"

    assert_text "Filter list was successfully created"
    click_on "Back"
  end

  test "should update Filter list" do
    visit filter_list_url(@filter_list)
    click_on "Edit this filter list", match: :first

    fill_in "Description", with: @filter_list.description
    fill_in "Email pattern", with: @filter_list.email_pattern
    fill_in "Name", with: @filter_list.name
    click_on "Update Filter list"

    assert_text "Filter list was successfully updated"
    click_on "Back"
  end

  test "should destroy Filter list" do
    visit filter_list_url(@filter_list)
    click_on "Destroy this filter list", match: :first

    assert_text "Filter list was successfully destroyed"
  end
end
