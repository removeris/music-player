require_relative "data-structures/doubly-linked-list"
require_relative "data-structures/linked-list"
require_relative "song"

require 'taglib'

class MusicPlayer
  attr_accessor :song_list
  
  def initialize
    @song_list = DataStructure::DoublyLinkedList.new()
  end

  def get_song_list()
    array = []
    i = 0

    while i < @song_list.length
      array[i] = @song_list.get(i).value
      i += 1
    end

    return array
  end

  def upload_song(path)
    new_song = Song.new()
    new_song.path = path
    
    TagLib::MPEG::File.open(path) do | file |
      tag = file.id3v2_tag
      
      new_song.title = tag.title
      new_song.artist = tag.artist
      new_song.duration = file.audio_properties.length_in_seconds
    end
  
    puts "#{new_song.title} #{new_song.artist} #{new_song.duration}"

    @song_list.push(new_song)

    puts @song_list.get(0).value.title
  end

  def upload_album(files, selection_list)
    song_idx = 1
    
    for file in files do
      for i in selection_list do
        if i == song_idx
          new_song = Song.new()
          new_song.path = file

          TagLib::MPEG::File.open(path) do | file |
            tag = file.id3v2_tag
            
            new_song.title = tag.title
            new_song.artist = tag.artist
            new_song.duration = file.audio_properties.length_in_seconds
          end

          song_list.push(new_song)
        end
      end
      song_idx += 1
    end

  end

  def upload_playlist()

  end

  def play_sequentially
    
  end

end