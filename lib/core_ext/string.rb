class String
    unless public_method_defined? :to_proc
        def to_proc &block
            params = []
            expr = self
            sections = expr.split(/\s*->\s*/m)
            if sections.length > 1 then
                eval_block(sections.reverse!.inject { |e, p| "(Proc.new { |#{p.split(/\s/).join(', ')}| #{e} })" }, block)
            elsif expr.match(/\b_\b/)
                eval_block("Proc.new { |_| #{expr} }", block)
            else
                leftSection = expr.match(/^\s*(?:[+*\/%&|\^\.=<>\[]|!=)/m)
                rightSection = expr.match(/[+\-*\/%&|\^\.=<>!]\s*$/m)
                if leftSection || rightSection then
                    if (leftSection) then
                        params.push('$left')
                        expr = '$left' + expr
                    end
                    if (rightSection) then
                        params.push('$right')
                        expr = expr + '$right'
                    end
                else
                    self.gsub(
                    /(?:\b[A-Z]|\.[a-zA-Z_$])[a-zA-Z_$\d]*|[a-zA-Z_$][a-zA-Z_$\d]*:|self|arguments|'(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*"/, ''
                    ).scan(
                    /([a-z_$][a-z_$\d]*)/i
                    ) do |v|
                        params.push(v) unless params.include?(v)
                    end
                end
                eval_block("Proc.new { |#{params.join(', ')}| #{expr} }", block)
            end
        end

        private
            def eval_block(code, block)
                eval code, block && block.binding
            end
    end
end
