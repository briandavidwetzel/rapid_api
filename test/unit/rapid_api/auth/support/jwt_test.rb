require File.expand_path '../../../../../test_helper.rb', __FILE__

class JwtTest < Minitest::Test

  def setup
    super
    @subject = RapidApi::Auth::Support::JWT
  end

  def teardown
    super
  end

  def test_encode
    payload = { user_id: 1 }
    refute_equal @subject.encode(payload), nil
  end

  def test_decode
    payload = { user_id: 1, secret: 'secret' }
    token   = @subject.encode(payload)

    decoded_token = @subject.decode(token)
    assert_equal decoded_token[0]['secret'], 'secret'
    assert_equal decoded_token[1]['alg'],    'none'
  end

end
