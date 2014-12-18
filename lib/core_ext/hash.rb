class Hash
    # like invert but not lossy
    # {1=>2,3=>2,2=>4}.inverse => {2=>[1, 3], 4=>[2]}
    def inverse
        self.each_with_object( {} ) { |(key, value), out| ( out[value] ||= [] ) << key }
    end
end
