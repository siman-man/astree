RSpec.describe ASTree do
  describe '.parse' do
    it 'test case 01' do
      code = <<~'CODE'
        true
      CODE

      expect = <<~'EXPECT'
        <SCOPE>
        ├───── []
        ├───── nil
        └───── <TRUE>
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'test case 02' do
      code = <<~'CODE'
        10.times do |i|
          puts i
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE>
        ├───── []
        ├───── nil
        └───── <ITER>
               ├───── <CALL>
               │      ├───── <LIT>
               │      │      └───── 10
               │      ├───── :times
               │      └───── nil
               └───── <SCOPE>
                      ├───── [:i]
                      ├───── <ARGS>
                      │      ├───── 1
                      │      ├───── nil
                      │      ├───── nil
                      │      ├───── nil
                      │      ├───── 0
                      │      ├───── nil
                      │      ├───── nil
                      │      ├───── nil
                      │      ├───── nil
                      │      └───── nil
                      └───── <FCALL>
                             ├───── :puts
                             └───── <ARRAY>
                                    ├───── <DVAR>
                                    │      └───── :i
                                    └───── nil
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end
  end
end
