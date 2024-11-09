# frozen_string_literal: true

# Thanks to https://github.com/xkwd/oxml

class HashParser < ::Ox::Sax
  EMPTY_STR = ''
  TRUE_STR = 'true'
  FALSE_STR = 'false'
  DATE_TIME = /^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:?\d{2})?$/
  DATE = /^-?\d{4}-\d{2}-\d{2}(?:Z|[+-]\d{2}:?\d{2})?$/
  TIME = /^\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:?\d{2})?$/

  def initialize(options = {})
    @memo = {}
    @arr = []
    @map = {}
    @name = nil
    @last_attr = nil
    @delete_namespace_attributes = options.fetch(:delete_namespace_attributes, false)
    @advanced_typecasting = options.fetch(:advanced_typecasting, false)
  end

  def to_h
    @memo.to_h
  end

  def attr(name, str)
    @last_attr = "#{name}:#{str}"
    return if @delete_namespace_attributes

    return if name == :version
    return if name == :encoding

    start_element(name)
    text(str)
    end_element(name)
  end

  def start_element(name)
    @arr.push(@memo)

    @name = @map[name] ||= name

    @memo = {}
    text(@memo)
  end

  def attrs_done
    return unless @last_attr =~ /nil:true/

    @last_attr = nil
    @arr.last[@name] = nil
  end

  def end_element(_name)
    @memo = @arr.pop
  end

  def text(value)
    if @arr.last[@name].is_a?(Array)
      @arr.last[@name].pop unless value == @memo
      @arr.last[@name] << cast(value)
    elsif @arr.last[@name] && value == @memo
      @arr.last[@name] = [@arr.last[@name], value]
    else
      @arr.last[@name] = cast(value)
    end
  end

  private

  def cast(value)
    return if value == EMPTY_STR
    return value unless @advanced_typecasting

    case value
    when EMPTY_STR then nil
    when TRUE_STR then true
    when FALSE_STR then false
    when DATE_TIME then DateTime.parse(value)
    when DATE then Date.parse(value)
    when TIME then Time.parse(value)
    else value
    end
  end
end
