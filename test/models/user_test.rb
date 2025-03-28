require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",password:"dheeraj",password_confirmation:"dheeraj")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should not be empty" do
    @user.email="  "
    assert_not @user.valid?
  end

  test "length of name should no be more than 50" do
    @user.name="a"*55
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password has minimum length" do
    @user.password = @user.password_confirmation ="a"* 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')

  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
    @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    # Users can't follow themselves.
    michael.follow(michael)
    assert_not michael.following?(michael)
  end
    

  test "feed should have the right posts" do
      michael = users(:michael)
      archer = users(:archer)
      lana = users(:lana)
      # Posts from followed user
      lana.microposts.each do |post_following|
        assert michael.feed.include?(post_following)
      end
      # Self-posts for user with followers
      michael.microposts.each do |post_self|
        assert michael.feed.include?(post_self)
      end
      # Posts from non-followed user
      archer.microposts.each do |post_unfollowed|
        assert_not michael.feed.include?(post_unfollowed)
      end
  end
end
