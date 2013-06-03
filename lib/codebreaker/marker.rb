module Codebreaker
  class Marker
    def self.mark(secret, guess)
      pos_match, num_match, leftover = 0, 0, secret.chars.to_a

      (0...secret.size).each {|i| leftover -= [guess[i]] if secret[i] == guess[i] }
      pos_match = secret.size - leftover.size

      (0...secret.size).each do |i|
        num_match += 1 if leftover.include?(guess[i])
        leftover -= [guess[i]]
      end

      '+'*pos_match + '-'*(num_match)
    end

  end
end
