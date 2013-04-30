require 'pathname'
class ManagerController < ApplicationController

  FolderFile = Struct.new(:type, :name, :path, :children)
  def index
    @files = directory_hash(Rails.public_path)
  end

  def directory_hash(path, name=nil)
    data = FolderFile.new('folder', name || path, Pathname.new(path).relative_path_from(Pathname.new(Rails.public_path)).to_s, []) 
    Dir.foreach(path) do |entry|
      next if (entry == '..' || entry == '.')
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        data.children << directory_hash(full_path, entry)
      else
        data.children << FolderFile.new('file', entry, Pathname.new(path).relative_path_from(Pathname.new(Rails.public_path)).to_s, [])
      end
    end
    return data
  end

  def delete
    File.delete(Rails.public_path+"#{params[:path]}")
    redirect_to :action => :index
  end
end