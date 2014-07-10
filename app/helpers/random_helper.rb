module RandomHelper
  def get_unique_random_string
    string = SecureRandom.hex(20)
    while($redis.sismember('random_unique', string))
      string = SecureRandom.hex(20)
    end

    $redis.sadd('random_unique', string)
    string
  end
end