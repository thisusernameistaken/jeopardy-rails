# encoding: utf-8

class GamefileUploader < CarrierWave::Uploader::Base

  storage :file

  def store_dir
    "game_files/#{model.id}"
  end

  def extension_white_list
    %w(xls xlsx)
  end

end
