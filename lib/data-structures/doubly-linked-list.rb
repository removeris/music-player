module DataStructure
  class DoublyLinkedList
    attr_accessor :head, :tail, :length

    def initialize()
      @head = nil
      @tail = nil
      @length = 0
    end

    # Insert to back

    def push(val)
      new_node = Node.new(val)

      if @length==0
          @head = new_node
          @tail = new_node
      else 
          @tail.next = new_node
          new_node.prev = @tail
          @tail = new_node
      end

      @length += 1
      
      return self
    end

    # Delete from back
    
    def pop
      return nil if !@head
      old_tail = @tail
      if @length==1
          @head = nil
          @tail = nil
      else 
          @tail = old_tail.prev
          @tail.next = nil
          old_tail.prev = nil 
      end
      @length -= 1
      return old_tail
    end

    # Add to front

    def unshift(val)
      new_node = Node.new(val)
      if @length==0 
          @head = new_node
          @tail = new_node
      else 
          @head.prev = new_node
          new_node.next = @head
          @head = new_node
      end
      @length += 1
      return self
    end

    # Delete from front

    def shift
      return nil if !@head
      old_head = @head
      if @length==1
          @head = nil
          @tail = nil
      else 
          @head = old_head.next
          @head.prev = nil
          old_head.next = nil 
      end
      @length -= 1
      return old_head
    end

    # Get value at index
    
    def get(index)
      return nil if index<0 || index>=@length
      if index<=@length/2
          i = 0
          current = @head
          while i<index do
              current = current.next
              i += 1
          end
      else 
          i = @length - 1
          current = @tail
          while i>index do
              current =  current.prev
              i -= 1
          end
      end
      return current
    end

    # Insert at index

    def insert(index, val)

      return false if index<0 || index>@length
      
      return !!unshift(val) if index==0
      
      return !!push(val) if index==@length
      
      new_node = Node.new(val)
      
      prev_node = get(index-1)
      after_new_node = prev_node.next

      new_node.prev = prev_node
      new_node.next = after_new_node

      prev_node.next = new_node
      after_new_node.prev = new_node
      
      @length += 1

      return true
    end

    # Delete at index
    
    def remove(index) 
      return nil if index<0 || index>=@length
      return shift() if index==0
      return pop() if index==@length-1
      removed_node = get(index)
      prev_node = removed_node.prev
      next_node = removed_node.next
      prev_node.next = next_node
      next_node.prev = prev_node
      removed_node.next = nil
      removed_node.prev = nil
      @length -= 1
      return removed_node
    end

    def clear
      @head = nil
      @length = 0
    end

    def insertion_sort(attribute)
      return if @head.nil? || @head.next.nil? 
  
      current = @head.next
      while current
        next_node = current.next  
  
        sorted = current.prev

        if(attribute == "artist")
          while sorted && sorted.value.artist > current.value.artist
            sorted = sorted.prev
          end
        elsif(attribute == "track number")
          while sorted && sorted.value.track_number > current.value.track_number
            sorted = sorted.prev
          end
        end

  
        # Remove current node
        if current.prev
          current.prev.next = current.next
        end
        if current.next
          current.next.prev = current.prev
        end
  
        # Insert current after sorted position
        if sorted.nil?  # Insert at the head if no sorted node is smaller
          current.next = @head
          @head.prev = current
          @head = current
          current.prev = nil
        else  # Insert in the middle or at the end
          current.next = sorted.next
          sorted.next.prev = current if sorted.next
          sorted.next = current
          current.prev = sorted
        end
  
        current = next_node
      end
    end

  end
end

class Node
  attr_accessor :value, :next, :prev

  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end
end