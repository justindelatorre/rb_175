class Advice
  def initialize
    @advice_list = [
      "Lost time is never found again.",
      "Oh, my friend, it's not what they take away from you that counts. It's what you do with what you have left."
    ]
  end

  def generate
    @advice_list.sample
  end
end
