require 'test_helper'

class TypusTest < ActiveSupport::TestCase

  test 'default_config for admin_title' do
    assert Typus.admin_title.eql?('Typus')
  end

  test 'default_config for default_locale' do
    assert Typus.default_locale.eql?(:en)
  end

  test 'default_config for available_locales' do
    assert Typus.available_locales.eql?({'English' => 'en'})
  end

  test 'default_config for admin_title_link' do
    assert Typus.admin_title_link.nil?
  end

  test 'default_config for authentication' do
    assert_equal :session, Typus.authentication
  end

  test 'default_config for mailer_sender' do
    assert_nil Typus.mailer_sender
  end

  test 'default_config for username' do
    assert Typus.username.eql?('admin')
  end

  test 'default_config for subdomain' do
    assert Typus.subdomain.nil?
  end

  test 'default_config for password' do
    assert Typus.password.eql?('columbia')
  end

  test 'default_config for file_preview and file_thumbnail (paperclip)' do
    assert Typus.file_preview.eql?(:medium)
    assert Typus.file_thumbnail.eql?(:thumb)
  end

  test 'default_config for image_preview_size and image_thumb_size (dragonfly)' do
    assert_equal '530x', Typus.image_preview_size
    assert_equal 'x100', Typus.image_thumb_size
  end

  test 'default_config for relationship' do
    assert Typus.relationship.eql?('typus_users')
  end

  test 'default_config for master_role' do
    assert Typus.master_role.eql?('admin')
  end

  test 'root is a Pathname' do
    assert Typus.root.is_a?(Pathname)
  end

  test 'config_folder is an String' do
    assert Typus.config_folder.is_a?(String)
  end

  test 'models are sorted' do
    config = {
      'View' => {},
      'AdminUser' => {},
      'Category' => {},
    }

    Typus::Configuration.stub(:config, config) do
      expected = %w(AdminUser Category View)
      assert_equal expected, Typus.models
    end
  end

  test 'resources class_method' do
    assert_equal %w(Git Status WatchDog), Typus.resources
  end

  test 'user_class returns default value' do
    assert_equal TypusUser, Typus.class
  end

  test 'user_class_name returns default value' do
    assert Typus.class.name.eql?('TypusUser')
  end

  test 'user_class_name setter presence' do
    assert Typus.respond_to?('user_class_name=')
  end

  test 'user_foreign_key returns default value' do
    assert_equal 'typus_user_id', Typus.user_foreign_key
  end

  test 'user_foreign_key setter presence' do
    assert Typus.respond_to?('user_foreign_key=')
  end

  test 'ip_whitelist setter with a default value' do
    assert Typus.ip_whitelist.empty?
  end

end
