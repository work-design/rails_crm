require "application_system_test_case"

class MaterialsTest < ApplicationSystemTestCase
  setup do
    @crm_panel_material = crm_panel_materials(:one)
  end

  test "visiting the index" do
    visit crm_panel_materials_url
    assert_selector "h1", text: "Materials"
  end

  test "should create material" do
    visit crm_panel_materials_url
    click_on "New material"

    fill_in "Picture", with: @crm_panel_material.picture
    click_on "Create Material"

    assert_text "Material was successfully created"
    click_on "Back"
  end

  test "should update Material" do
    visit crm_panel_material_url(@crm_panel_material)
    click_on "Edit this material", match: :first

    fill_in "Picture", with: @crm_panel_material.picture
    click_on "Update Material"

    assert_text "Material was successfully updated"
    click_on "Back"
  end

  test "should destroy Material" do
    visit crm_panel_material_url(@crm_panel_material)
    click_on "Destroy this material", match: :first

    assert_text "Material was successfully destroyed"
  end
end
