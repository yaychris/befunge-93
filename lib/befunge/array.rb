class Array
  def ljust(length, pad = nil)
    arr = self.clone
    if arr.length < length
      arr.length.upto(length - 1) { arr << pad }
    end
    arr
  end
end