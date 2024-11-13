require_relative "data-structures/doubly-linked-list"
require_relative "data-structures/linked-list"
require_relative "song"

require 'json'
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
      new_song.track_number = tag.track
    end

    @song_list.push(new_song)
  end

  def upload_album(path, files, selection_list)
    song_idx = 1

    for file in files do
      for i in selection_list do
        if i.to_i == song_idx
          new_song = Song.new()
          new_song.path = file

          TagLib::MPEG::File.open(file) do | file |
            tag = file.id3v2_tag
            
            new_song.title = tag.title
            new_song.artist = tag.artist
            new_song.duration = file.audio_properties.length_in_seconds
            new_song.track_number = tag.track
          end

          @song_list.push(new_song)
        end
      end
      song_idx += 1
    end

  end

  def upload_playlist(path)
    
    @song_list.clear

    file = File.read(path)
    data_hash = JSON.parse(file)

    data_hash.each do | id, data |
      new_song = Song.new()

      new_song.path = data["path"]
      new_song.title = data["title"]
      new_song.artist = data["artist"]

      @song_list.push(new_song)
    end
  end

  def delete_song(index)
    @song_list.remove(index - 1)
  end

  def change_song_location(selection, location)
    selected_node = @song_list.get(selection - 1)
    node_at_location = @song_list.get(location - 1)

    temp = selected_node.value

    selected_node.value = node_at_location.value
    node_at_location.value = temp
  end

  def sort_by_artist()
    @song_list.insertion_sort("artist")
  end

  def sort_by_track_number()
    @song_list.insertion_sort("track_number")
  end

  def create_playlist(name, selection_list)
    out_file = File.new("./playlists/#{name}.json", "w+")

    attribute_hash = Hash.new()

    idx = 1
    for item in selection_list do
    
      temp = @song_list.get(item.to_i - 1)

      attribute_hash["#{idx}"] = {
        artist: temp.value.artist,
        title: temp.value.title,
        path: temp.value.path
      }

      
      idx += 1
    end

    out_file.puts(JSON.pretty_generate(attribute_hash))
    
    out_file.close()
  end

end