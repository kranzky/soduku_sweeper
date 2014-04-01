module GenericObserver
    def update(command, *data)
        if methods.include?(command)
            eval("#{command}(*data)")
        else
            puts "Command not found: #{command}(#{data.join(', ')})"
        end
    end
end
