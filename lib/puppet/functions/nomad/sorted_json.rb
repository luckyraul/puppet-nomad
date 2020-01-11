require 'json'

Puppet::Functions.create_function(:'nomad::sorted_json') do
  def sorted_json(unsorted_hash = {}, pretty = false, indent_len = 4)
    quoted = false
    # simplify jsonification of standard types
    simple_generate = lambda do |obj|
      case obj
        when NilClass, :undef
          'null'
        when Integer, Float, TrueClass, FalseClass
          if quoted then
            "\"#{obj}\""
          else
            "#{obj}"
          end
        else
          # Should be a string
          # keep string integers unquoted
          (obj =~ /\A[-]?(0|[1-9]\d*)\z/ && !quoted) ? obj : obj.to_json
      end
    end

    sorted_generate = lambda do |obj|
      case obj
        when NilClass, :undef, Integer, Float, TrueClass, FalseClass, String
          return simple_generate.call(obj)
        when Array
          arrayRet = []
          obj.each do |a|
            arrayRet.push(sorted_generate.call(a))
          end
          return "[" << arrayRet.join(',') << "]";
        when Hash
          ret = []
          obj.keys.sort.each do |k|
            if k =~ /\A(node_meta|meta|tags)\z/ then
              quoted = true
            elsif k =~ /\A(weights)\z/ then
              quoted = false
            end
            ret.push(k.to_json << ":" << sorted_generate.call(obj[k]))
          end
          quoted = false
          return "{" << ret.join(",") << "}";
        else
          raise Exception.new("Unable to handle object of type #{obj.class.name} with value #{obj.inspect}")
      end
    end

    sorted_pretty_generate = lambda do |obj, indent_len=4, level=0|
      # Indent length
      indent = " " * indent_len

      case obj
        when NilClass, :undef, Integer, Float, TrueClass, FalseClass, String
          return simple_generate.call(obj)
        when Array
          arrayRet = []

          level += 1
          obj.each do |a|
            arrayRet.push(sorted_pretty_generate.call(a, indent_len, level))
          end
          level -= 1

          return "[\n#{indent * (level + 1)}" << arrayRet.join(",\n#{indent * (level + 1)}") << "\n#{indent * level}]";

        when Hash
          ret = []

          # This level works in a similar way to the above
          level += 1
          obj.keys.sort.each do |k|
            if k =~ /\A(node_meta|meta|tags)\z/ then
              quoted = true
            elsif k =~ /\A(weights)\z/ then
              quoted = false
            end
            ret.push("#{indent * level}" << k.to_json << ": " << sorted_pretty_generate.call(obj[k], indent_len, level))
          end
          level -= 1

          quoted = false
          return "{\n" << ret.join(",\n") << "\n#{indent * level}}";
        else
          raise Exception.new("Unable to handle object of type #{obj.class.name} with value #{obj.inspect}")
      end
    end

    if pretty
      return sorted_pretty_generate.call(unsorted_hash, indent_len) << "\n"
    else
      return sorted_generate.call(unsorted_hash)
    end
  end
end
