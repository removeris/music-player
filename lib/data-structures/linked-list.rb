module DataStructureOne
  class SinglyLinkedList
    attr_accessor :head

    def initialize
      @head = nil
    end
    
    #is_empty?: return true if the linked list is empty
    def is_empty?
      if @head == nil
          return true
      else
          return false
      end
    end

    # Insert to back
    def push(data)
        if self.is_empty?
            @head = Node.new(data)
        else
            current_node = @head
            new_node = Node.new(data)
            while current_node.next != nil
                current_node = current_node.next
            end
            current_node.next = new_node
        end
    end
  
    # Insert to front
    def unshift(data)
        if self.is_empty?
            @head = Node.new(data)
        else
            curr_head = Node.new(data)
            curr_head.next = @head
            @head = curr_head
        end
    end

    # Remove last node
    def pop
        if self.is_empty?
            return "This list is currently empty"
        else
            current_node = @head
            while current_node.next.next != nil
                current_node = current_node.next
            end
            last_node = current_node.next
            current_node.next = nil
        end
        last_node
    end
  
    # Remove first node
    def shift
        if self.is_empty?
            return "This list is currently empty"
        else
            curr_head = @head
            new_head = @head.next
            @head.next = nil
            @head = new_head
        end
        curr_head
    end
  
    # Return size
    def size
        if self.is_empty?
            count = 0
        else
            count = 1
            current_node = @head
            while current_node.next != nil
                current_node = current_node.next
                count += 1
            end
        end
        count
    end
  
    # Clear list
    def clear
        @head = nil
    end
  end


    class Node    
        attr_accessor :data, :next

        def initialize(data, next_node = nil)
            @data = data
            @next = next_node
        end
    end
end

