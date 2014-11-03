# Monkey patch Array class to traverse the array infinitely (when reaches the end goes back to the start) -- similar to
# a LinkedList where the last.next pointer points to the start of the array. Old implementation left in on purpose.
# Patch acceptable because only extending functionality and couldn't find alternative solution online.
class Array
  def next_elem_infinite(item)
    index = self.index(item)

    if (!index.nil?)
      if (index == (self.length - 1))
        index = -1
      end

      self[index + 1]
    end
  end

  def prev_elem_infinite(item)
    index = self.index(item)

    if (!index.nil?)
      if (index == 0)
        index = self.length
      end

      self[index - 1]
    end
  end
end