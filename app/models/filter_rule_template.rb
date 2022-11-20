class FilterRuleTemplate < ApplicationRecord
  validates :name, presence: true
  validates :email_pattern, presence: true

  # Default Gmail filter criteria string has a max length of 1500, chop
  # the email pattern into syntactically valid chunks within length limits
  def email_pattern_as_array_for_gmail(string_to_split: email_pattern, max_length: 1500, separator: " OR ")
    head = string_to_split[0..(max_length - 1)]

    # Partition bang on just before last separator within the limit
    reversed_index_of_last_separator = head.reverse.index(separator.reverse)
    index_of_last_full_email_pattern = max_length - reversed_index_of_last_separator - separator.length
    _, clean_head, tail = string_to_split.partition(/.{#{index_of_last_full_email_pattern}}/)

    # Tail will start with a separator, chop it off
    clean_tail = tail.sub(separator, "")

    if tail.size <= max_length
      [clean_head, clean_tail]
    else
      chunked_tail = email_pattern_as_array_for_gmail(string_to_split: clean_tail, max_length: max_length, separator: separator)
      [clean_head].concat(chunked_tail)
    end.compact
  end
end
