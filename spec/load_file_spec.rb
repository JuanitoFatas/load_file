RSpec.describe LoadFile do
  describe "Not overrides content" do
    after { Object.send(:remove_const, :App) }

    it "load" do
      LoadFile.load(file: sample_yaml_path, constant: :App)

      LoadFile.load(file: sample_json_path, constant: :App)

      expect(App["open"]["app_url"]).to eq "http://localhost:3000/yaml"
    end

    it "load_files" do
      LoadFile.load(file: sample_yaml_path, constant: :App)

      LoadFile.load_files(files: [sample_json_path], constant: :App)

      expect(App["open"]["app_url"]).to eq "http://localhost:3000/yaml"
    end
  end

  describe "overrides content" do
    after { Object.send(:remove_const, :App) }

    it "overload" do
      LoadFile.load(file: sample_yaml_path, constant: :App)

      LoadFile.overload(file: sample_json_path, constant: :App)

      expect(App["open"]["app_url"]).to eq "http://localhost:3000/json"
    end

    it "overload_files" do
      LoadFile.load(file: sample_yaml_path, constant: :App)

      LoadFile.overload_files(files: [sample_json_path], constant: :App)

      expect(App["open"]["app_url"]).to eq "http://localhost:3000/json"
    end
  end

  describe "not raises error for non-existent file" do
    it "load" do
      LoadFile.load(file: "not_exists.yml", constant: :App)
    end

    it "load_files" do
      LoadFile.load_files(files: ["not_exists.yml"], constant: :App)
    end

    it "overload" do
      LoadFile.overload(file: "not_exists.yml", constant: :App)
    end

    it "overload_files" do
      LoadFile.overload_files(files: ["not_exists.yml"], constant: :App)
    end
  end

  describe "raises error for non-existent files" do
    it "load!" do
      expect do
        LoadFile.load!(file: "not_exists.yml", constant: :App)
      end.to raise_error(Errno::ENOENT)
    end

    it "load_files!" do
      expect do
        LoadFile.load_files!(files: ["not_exists.yml"], constant: :App)
      end.to raise_error(Errno::ENOENT)
    end

    it "overload!" do
      expect do
        LoadFile.overload!(file: "not_exists.yml", constant: :App)
      end.to raise_error(Errno::ENOENT)
    end

    it "overload_files!" do
      expect do
        LoadFile.overload_files!(files: ["not_exists.yml"], constant: :App)
      end.to raise_error(Errno::ENOENT)
    end
  end

  describe "bad content" do
    it "raises error for bad yaml" do
      expect do
        LoadFile.load(file: bad_yaml_path, constant: :BadYaml)
      end.to raise_error(
        LoadFile::Parser::ParserError,
        "spec/fixtures/bad.yml format is invalid"
      )
    end

    it "raises error for bad json" do
      expect do
        LoadFile.load(file: bad_json_path, constant: :BadJson)
      end.to raise_error(
        LoadFile::Parser::ParserError,
        "spec/fixtures/bad.json format is invalid"
      )
    end
  end

  describe "unknown format" do
    it "raises error" do
      expect do
        LoadFile.load(file: "dev.ini", constant: :DevIni)
      end.to raise_error(
        LoadFile::Parser::ParserError,
        "dev.ini format is invalid"
      )
    end
  end
end
