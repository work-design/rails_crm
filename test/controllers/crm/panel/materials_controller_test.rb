require 'test_helper'
class Crm::Panel::MaterialsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @material = materials(:one)
  end

  test 'index ok' do
    get url_for(controller: 'crm/panel/materials')

    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'crm/panel/materials')

    assert_response :success
  end

  test 'create ok' do
    assert_difference('Material.count') do
      post(
        url_for(controller: 'crm/panel/materials', action: 'create'),
        params: { material: { picture: @crm_panel_material.picture } },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'crm/panel/materials', action: 'show', id: @material.id)

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'crm/panel/materials', action: 'edit', id: @material.id)

    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'crm/panel/materials', action: 'update', id: @material.id),
      params: { material: { picture: @crm_panel_material.picture } },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('Material.count', -1) do
      delete url_for(controller: 'crm/panel/materials', action: 'destroy', id: @material.id), as: :turbo_stream
    end

    assert_response :success
  end

end
