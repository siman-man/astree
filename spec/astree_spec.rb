RSpec.describe ASTree do
  describe '.parse' do
    it 'if' do
      code = <<~'CODE'
        if x == 1 then
          foo
        else
          bar
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-5:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <IF> [1:0-5:3]
               ├───── <OPCALL> [1:3-1:9]
               │      ├───── <VCALL> [1:3-1:4]
               │      │      └───── :x (method id)
               │      ├───── :== (method id)
               │      └───── <ARRAY> [1:8-1:9]
               │             ├───── <LIT> [1:8-1:9]
               │             │      └───── 1 (value)
               │             └───── nil (unknown)
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               └───── <VCALL> [4:2-4:5]
                      └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'unless' do
      code = <<~'CODE'
        unless x == 1 then
          foo
        else
          bar
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-5:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <UNLESS> [1:0-5:3]
               ├───── <OPCALL> [1:7-1:13]
               │      ├───── <VCALL> [1:7-1:8]
               │      │      └───── :x (method id)
               │      ├───── :== (method id)
               │      └───── <ARRAY> [1:12-1:13]
               │             ├───── <LIT> [1:12-1:13]
               │             │      └───── 1 (value)
               │             └───── nil (unknown)
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               └───── <VCALL> [4:2-4:5]
                      └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'unless without else' do
      code = <<~'CODE'
        unless x == 1 then
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <UNLESS> [1:0-3:3]
               ├───── <OPCALL> [1:7-1:13]
               │      ├───── <VCALL> [1:7-1:8]
               │      │      └───── :x (method id)
               │      ├───── :== (method id)
               │      └───── <ARRAY> [1:12-1:13]
               │             ├───── <LIT> [1:12-1:13]
               │             │      └───── 1 (value)
               │             └───── nil (unknown)
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               └───── nil (else clause)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'case' do
      code = <<~'CODE'
        case x
        when 1
          foo
        else
          baz
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-6:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CASE> [1:0-6:3]
               ├───── <VCALL> [1:5-1:6]
               │      └───── :x (method id)
               └───── <WHEN> [2:0-5:5]
                      ├───── <ARRAY> [2:5-2:6]
                      │      ├───── <LIT> [2:5-2:6]
                      │      │      └───── 1 (value)
                      │      └───── nil (unknown)
                      ├───── <VCALL> [3:2-3:5]
                      │      └───── :foo (method id)
                      └───── <VCALL> [5:2-5:5]
                             └───── :baz (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'case 2' do
      code = <<~'CODE'
        case
        when 1
          foo
        else
          baz
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-6:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CASE2> [1:0-6:3]
               ├───── nil (condition)
               └───── <WHEN> [2:0-5:5]
                      ├───── <ARRAY> [2:5-2:6]
                      │      ├───── <LIT> [2:5-2:6]
                      │      │      └───── 1 (value)
                      │      └───── nil (unknown)
                      ├───── <VCALL> [3:2-3:5]
                      │      └───── :foo (method id)
                      └───── <VCALL> [5:2-5:5]
                             └───── :baz (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'when' do
      code = <<~'CODE'
        case
        when 1
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-4:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CASE2> [1:0-4:3]
               ├───── nil (condition)
               └───── <WHEN> [2:0-3:5]
                      ├───── <ARRAY> [2:5-2:6]
                      │      ├───── <LIT> [2:5-2:6]
                      │      │      └───── 1 (value)
                      │      └───── nil (unknown)
                      ├───── <VCALL> [3:2-3:5]
                      │      └───── :foo (method id)
                      └───── nil (next clause)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'while' do
      code = <<~'CODE'
        while x == 1
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <WHILE> [1:0-3:3]
               ├───── <OPCALL> [1:6-1:12]
               │      ├───── <VCALL> [1:6-1:7]
               │      │      └───── :x (method id)
               │      ├───── :== (method id)
               │      └───── <ARRAY> [1:11-1:12]
               │             ├───── <LIT> [1:11-1:12]
               │             │      └───── 1 (value)
               │             └───── nil (unknown)
               └───── <VCALL> [2:2-2:5]
                      └───── :foo (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'until' do
      code = <<~'CODE'
        until x == 1
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <UNTIL> [1:0-3:3]
               ├───── <OPCALL> [1:6-1:12]
               │      ├───── <VCALL> [1:6-1:7]
               │      │      └───── :x (method id)
               │      ├───── :== (method id)
               │      └───── <ARRAY> [1:11-1:12]
               │             ├───── <LIT> [1:11-1:12]
               │             │      └───── 1 (value)
               │             └───── nil (unknown)
               └───── <VCALL> [2:2-2:5]
                      └───── :foo (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'for' do
      code = <<~'CODE'
        for x in 1..3 do
          foo 
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [:x] (local table)
        ├───── nil (arguments)
        └───── <FOR> [1:0-3:3]
               ├───── <DOT2> [1:9-1:13]
               │      ├───── <LIT> [1:9-1:10]
               │      │      └───── 1 (value)
               │      └───── <LIT> [1:12-1:13]
               │             └───── 3 (value)
               └───── <SCOPE> [1:0-3:3]
                      ├───── [nil] (local table)
                      ├───── <ARGS> [1:4-1:5]
                      │      ├───── 1 (pre_num)
                      │      ├───── <LASGN> [1:4-1:5]
                      │      │      ├───── :x (variable name)
                      │      │      └───── <DVAR> [1:4-1:5]
                      │      │             └───── nil (variable name)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── <VCALL> [2:2-2:5]
                             └───── :foo (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'for_masgn' do
      code = <<~'CODE'
        for x, y in 1..3
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [:x, :y] (local table)
        ├───── nil (arguments)
        └───── <FOR> [1:0-3:3]
               ├───── <DOT2> [1:12-1:16]
               │      ├───── <LIT> [1:12-1:13]
               │      │      └───── 1 (value)
               │      └───── <LIT> [1:15-1:16]
               │             └───── 3 (value)
               └───── <SCOPE> [1:0-3:3]
                      ├───── [nil] (local table)
                      ├───── <ARGS> [1:4-1:8]
                      │      ├───── 0 (pre_num)
                      │      ├───── <MASGN> [1:4-1:8]
                      │      │      ├───── <FOR_MASGN> [1:4-1:8]
                      │      │      │      └───── <DVAR> [1:4-1:8]
                      │      │      │             └───── nil (variable name)
                      │      │      ├───── <ARRAY> [1:4-1:8]
                      │      │      │      ├───── <LASGN> [1:4-1:5]
                      │      │      │      │      ├───── :x (variable name)
                      │      │      │      │      └───── nil 
                      │      │      │      ├───── <LASGN> [1:7-1:8]
                      │      │      │      │      ├───── :y (variable name)
                      │      │      │      │      └───── nil 
                      │      │      │      └───── nil (unknown)
                      │      │      └───── nil (rest variable)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── <VCALL> [2:2-2:5]
                             └───── :foo (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'ensure' do
      code = <<~'CODE'
        begin
          foo
        ensure
          bar
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-5:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ENSURE> [2:2-4:5]
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               └───── <VCALL> [4:2-4:5]
                      └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'and' do
      code = <<~'CODE'
        foo && bar
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:10]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <AND> [1:0-1:10]
               ├───── <VCALL> [1:0-1:3]
               │      └───── :foo (method id)
               └───── <VCALL> [1:7-1:10]
                      └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'or' do
      code = <<~'CODE'
        foo || bar
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:10]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <OR> [1:0-1:10]
               ├───── <VCALL> [1:0-1:3]
               │      └───── :foo (method id)
               └───── <VCALL> [1:7-1:10]
                      └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'iasgn' do
      code = <<~'CODE'
        @x = 1
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:6]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <IASGN> [1:0-1:6]
               ├───── :@x (variable name)
               └───── <LIT> [1:5-1:6]
                      └───── 1 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'casgn' do
      code = <<~'CODE'
        @@x = 2
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:7]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CVASGN> [1:0-1:7]
               ├───── :@@x (variable name)
               └───── <LIT> [1:6-1:7]
                      └───── 2 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'gasgn' do
      code = <<~'CODE'
        $x = 3
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:6]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <GASGN> [1:0-1:6]
               ├───── :$x (variable name)
               └───── <LIT> [1:5-1:6]
                      └───── 3 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'op_asgn1' do
      code = <<~'CODE'
        ary[1] += 1
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:11]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <OP_ASGN1> [1:0-1:11]
               ├───── <VCALL> [1:0-1:3]
               │      └───── :ary (method id)
               ├───── :+ (operator)
               ├───── <ARRAY> [1:4-1:5]
               │      ├───── <LIT> [1:4-1:5]
               │      │      └───── 1 (value)
               │      └───── nil (unknown)
               └───── <LIT> [1:10-1:11]
                      └───── 1 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'op_asgn2' do
      code = <<~'CODE'
        struct.field += 1
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:17]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <OP_ASGN2> [1:0-1:17]
               ├───── <VCALL> [1:0-1:6]
               │      └───── :struct (method id)
               ├───── false (unknown)
               ├───── :field (field name)
               └───── <LIT> [1:16-1:17]
                      └───── 1 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'op_asgn_and' do
      code = <<~'CODE'
        foo &&= bar
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:11]
        ├───── [:foo] (local table)
        ├───── nil (arguments)
        └───── <OP_ASGN_AND> [1:0-1:11]
               ├───── <LVAR> [1:0-1:3]
               │      └───── :foo (variable name)
               ├───── :"&&" (operator)
               └───── <LASGN> [1:0-1:11]
                      ├───── :foo (variable name)
                      └───── <VCALL> [1:8-1:11]
                             └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'op_asgn_or' do
      code = <<~'CODE'
        foo ||= bar
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:11]
        ├───── [:foo] (local table)
        ├───── nil (arguments)
        └───── <OP_ASGN_OR> [1:0-1:11]
               ├───── <LVAR> [1:0-1:3]
               │      └───── :foo (variable name)
               ├───── :"||" (operator)
               └───── <LASGN> [1:0-1:11]
                      ├───── :foo (variable name)
                      └───── <VCALL> [1:8-1:11]
                             └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'op_cdecl' do
      code = <<~'CODE'
        A::B ||= 1
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:10]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <OP_CDECL> [1:0-1:10]
               ├───── <COLON2> [1:0-1:4]
               │      ├───── <CONST> [1:0-1:1]
               │      │      └───── :A (const name)
               │      └───── :B (const name)
               ├───── :"||" (operator)
               └───── <LIT> [1:9-1:10]
                      └───── 1 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'call' do
      code = <<~'CODE'
        obj.foo(1)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:10]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CALL> [1:0-1:10]
               ├───── <VCALL> [1:0-1:3]
               │      └───── :obj (method id)
               ├───── :foo (method id)
               └───── <ARRAY> [1:8-1:9]
                      ├───── <LIT> [1:8-1:9]
                      │      └───── 1 (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'opcall' do
      code = <<~'CODE'
        foo + bar
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:9]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <OPCALL> [1:0-1:9]
               ├───── <VCALL> [1:0-1:3]
               │      └───── :foo (method id)
               ├───── :+ (method id)
               └───── <ARRAY> [1:6-1:9]
                      ├───── <VCALL> [1:6-1:9]
                      │      └───── :bar (method id)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'fcall' do
      code = <<~'CODE'
        foo(1)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:6]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <FCALL> [1:0-1:6]
               ├───── :foo (method id)
               └───── <ARRAY> [1:4-1:5]
                      ├───── <LIT> [1:4-1:5]
                      │      └───── 1 (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'vcall' do
      code = <<~'CODE'
        foo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <VCALL> [1:0-1:3]
               └───── :foo (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'qcall' do
      code = <<~'CODE'
        obj&.foo(1)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:11]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <QCALL> [1:0-1:11]
               ├───── <VCALL> [1:0-1:3]
               │      └───── :obj (method id)
               ├───── :foo (method id)
               └───── <ARRAY> [1:9-1:10]
                      ├───── <LIT> [1:9-1:10]
                      │      └───── 1 (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'qcall without arguments' do
      code = <<~'CODE'
        obj&.foo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:8]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <QCALL> [1:0-1:8]
               ├───── <VCALL> [1:0-1:3]
               │      └───── :obj (method id)
               ├───── :foo (method id)
               └───── nil (arguments)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'super' do
      code = <<~'CODE'
        super(1)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:8]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <SUPER> [1:0-1:8]
               └───── <ARRAY> [1:6-1:7]
                      ├───── <LIT> [1:6-1:7]
                      │      └───── 1 (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'super without arguments' do
      code = <<~'CODE'
        super()
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:7]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <SUPER> [1:0-1:7]
               └───── nil (arguments)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'zsuper' do
      code = <<~'CODE'
        super
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:5]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ZSUPER> [1:0-1:5]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'zarray' do
      code = <<~'CODE'
        []
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:2]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ZARRAY> [1:0-1:2]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'values' do
      code = <<~'CODE'
        return 1, 2, 3
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:14]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <RETURN> [1:0-1:14]
               └───── <VALUES> [1:7-1:14]
                      ├───── <LIT> [1:7-1:8]
                      │      └───── 1 (value)
                      ├───── <LIT> [1:10-1:11]
                      │      └───── 2 (value)
                      ├───── <LIT> [1:13-1:14]
                      │      └───── 3 (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'hash' do
      code = <<~'CODE'
        { a: 1, b: 2 }
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:14]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <HASH> [1:0-1:14]
               └───── <ARRAY> [1:2-1:12]
                      ├───── <LIT> [1:2-1:4]
                      │      └───── :a (value)
                      ├───── <LIT> [1:5-1:6]
                      │      └───── 1 (value)
                      ├───── <LIT> [1:8-1:10]
                      │      └───── :b (value)
                      ├───── <LIT> [1:11-1:12]
                      │      └───── 2 (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'yield' do
      code = <<~'CODE'
        yield
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:5]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <YIELD> [1:0-1:5]
               └───── nil (arguments)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'lvar' do
      code = <<~'CODE'
        x = 1
        x
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-2:1]
        ├───── [:x] (local table)
        ├───── nil (arguments)
        └───── <BLOCK> [1:0-2:1]
               ├───── <LASGN> [1:0-1:5]
               │      ├───── :x (variable name)
               │      └───── <LIT> [1:4-1:5]
               │             └───── 1 (value)
               └───── <LVAR> [2:0-2:1]
                      └───── :x (variable name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dvar' do
      code = <<~'CODE'
        1.times { x = 1; x }
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:20]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ITER> [1:0-1:20]
               ├───── <CALL> [1:0-1:7]
               │      ├───── <LIT> [1:0-1:1]
               │      │      └───── 1 (value)
               │      ├───── :times (method id)
               │      └───── nil (arguments)
               └───── <SCOPE> [1:8-1:20]
                      ├───── [:x] (local table)
                      ├───── nil (arguments)
                      └───── <BLOCK> [1:10-1:18]
                             ├───── <DASGN_CURR> [1:10-1:15]
                             │      ├───── :x (variable name)
                             │      └───── <LIT> [1:14-1:15]
                             │             └───── 1 (value)
                             └───── <DVAR> [1:17-1:18]
                                    └───── :x (variable name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'ivar' do
      code = <<~'CODE'
        @i
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:2]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <IVAR> [1:0-1:2]
               └───── :@i (variable name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'const' do
      code = <<~'CODE'
        X
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:1]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CONST> [1:0-1:1]
               └───── :X (const name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'cvar' do
      code = <<~'CODE'
        @@x
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CVAR> [1:0-1:3]
               └───── :@@x (variable name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'gvar' do
      code = <<~'CODE'
        $x
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:2]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <GVAR> [1:0-1:2]
               └───── :$x (variable name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'true' do
      code = <<~'CODE'
        true
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:4]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <TRUE> [1:0-1:4]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'break' do
      code = <<~'CODE'
        break
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:5]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <BREAK> [1:0-1:5]
               └───── nil (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'break with value' do
      code = <<~'CODE'
        break 3
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:7]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <BREAK> [1:0-1:7]
               └───── <LIT> [1:6-1:7]
                      └───── 3 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'next' do
      code = <<~'CODE'
        next
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:4]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <NEXT> [1:0-1:4]
               └───── nil (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'next with value' do
      code = <<~'CODE'
        next 3
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:6]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <NEXT> [1:0-1:6]
               └───── <LIT> [1:5-1:6]
                      └───── 3 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'redo' do
      code = <<~'CODE'
        redo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:4]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <REDO> [1:0-1:4]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'retry' do
      code = <<~'CODE'
        retry
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:5]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <RETRY> [1:0-1:5]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'begin' do
      code = <<~'CODE'
        begin
          1
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <LIT> [2:2-2:3]
               └───── 1 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'rescue' do
      code = <<~'CODE'
        begin
          foo
        rescue
          bar
        else
          baz
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-7:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <RESCUE> [2:2-6:5]
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               ├───── <RESBODY> [3:0-4:5]
               │      ├───── nil (rescue clause list)
               │      ├───── <VCALL> [4:2-4:5]
               │      │      └───── :bar (method id)
               │      └───── nil (next clause)
               └───── <VCALL> [6:2-6:5]
                      └───── :baz (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'postexe' do
      code = <<~'CODE'
        END { foo }
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:11]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <POSTEXE> [1:0-1:11]
               └───── <SCOPE> [1:0-1:11]
                      ├───── [] (local table)
                      ├───── nil (arguments)
                      └───── <VCALL> [1:6-1:9]
                             └───── :foo (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'begin' do
      code = <<~'CODE'
        BEGIN { foo }
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:13]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <BLOCK> [1:6-1:13]
               ├───── <BEGIN> [1:6-1:13]
               │      └───── <VCALL> [1:8-1:11]
               │             └───── :foo (method id)
               └───── <BEGIN> [1:6-1:13]
                      └───── nil (body)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'attrasgn' do
      code = <<~'CODE'
        struct.field = foo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:18]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ATTRASGN> [1:0-1:18]
               ├───── <VCALL> [1:0-1:6]
               │      └───── :struct (method id)
               ├───── :field= (method id)
               └───── <ARRAY> [1:15-1:18]
                      ├───── <VCALL> [1:15-1:18]
                      │      └───── :foo (method id)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'methref' do
      pending('`.:` support RUBY_VERSION >= "2.7.0"')
      code = <<~'CODE'
        foo.:method
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:18]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ATTRASGN> [1:0-1:18]
               ├───── <VCALL> [1:0-1:6]
               │      └───── :struct (method id)
               ├───── :field= (method id)
               └───── <ARRAY> [1:15-1:18]
                      ├───── <VCALL> [1:15-1:18]
                      │      └───── :foo (method id)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'lambda' do
      code = <<~'CODE'
        -> { foo }
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:10]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <LAMBDA> [1:0-1:10]
               └───── <SCOPE> [1:2-1:10]
                      ├───── [] (local table)
                      ├───── <ARGS> [1:2-1:2]
                      │      ├───── 0 (pre_num)
                      │      ├───── nil (pre_init)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── <VCALL> [1:5-1:8]
                             └───── :foo (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'opt_arg' do
      code = <<~'CODE'
        def foo(a, b = 1, d = 4, c)
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-2:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DEFN> [1:0-2:3]
               ├───── :foo (method id)
               └───── <SCOPE> [1:0-2:3]
                      ├───── [:a, :b, :d, :c] (local table)
                      ├───── <ARGS> [1:8-1:26]
                      │      ├───── 1 (pre_num)
                      │      ├───── nil (pre_init)
                      │      ├───── <OPT_ARG> [1:11-1:23]
                      │      │      ├───── <LASGN> [1:11-1:16]
                      │      │      │      ├───── :b (variable name)
                      │      │      │      └───── <LIT> [1:15-1:16]
                      │      │      │             └───── 1 (value)
                      │      │      └───── <OPT_ARG> [1:18-1:23]
                      │      │             ├───── <LASGN> [1:18-1:23]
                      │      │             │      ├───── :d (variable name)
                      │      │             │      └───── <LIT> [1:22-1:23]
                      │      │             │             └───── 4 (value)
                      │      │             └───── nil (next opt_arg)
                      │      ├───── :c (first_post)
                      │      ├───── 1 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── nil (body)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'kw_arg' do
      code = <<~'CODE'
        def foo(a: 1, b: 2)
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-2:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DEFN> [1:0-2:3]
               ├───── :foo (method id)
               └───── <SCOPE> [1:0-2:3]
                      ├───── [:a, :b, nil] (local table)
                      ├───── <ARGS> [1:8-1:18]
                      │      ├───── 0 (pre_num)
                      │      ├───── nil (pre_init)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── <KW_ARG> [1:8-1:18]
                      │      │      ├───── <LASGN> [1:8-1:12]
                      │      │      │      ├───── :a (variable name)
                      │      │      │      └───── <LIT> [1:11-1:12]
                      │      │      │             └───── 1 (value)
                      │      │      └───── <KW_ARG> [1:14-1:18]
                      │      │             ├───── <LASGN> [1:14-1:18]
                      │      │             │      ├───── :b (variable name)
                      │      │             │      └───── <LIT> [1:17-1:18]
                      │      │             │             └───── 2 (value)
                      │      │             └───── nil (next kw_arg)
                      │      ├───── <DVAR> [1:8-1:18]
                      │      │      └───── nil (variable name)
                      │      └───── nil (block)
                      └───── nil (body)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'post_arg' do
      code = <<~'CODE'
        a, *rest, z = foo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:17]
        ├───── [:a, :rest, :z] (local table)
        ├───── nil (arguments)
        └───── <MASGN> [1:0-1:17]
               ├───── <VCALL> [1:14-1:17]
               │      └───── :foo (method id)
               ├───── <ARRAY> [1:0-1:1]
               │      ├───── <LASGN> [1:0-1:1]
               │      │      ├───── :a (variable name)
               │      │      └───── nil 
               │      └───── nil (unknown)
               └───── <POSTARG> [1:0-1:11]
                      ├───── <LASGN> [1:4-1:8]
                      │      ├───── :rest (variable name)
                      │      └───── nil 
                      └───── <ARRAY> [1:10-1:11]
                             ├───── <LASGN> [1:10-1:11]
                             │      ├───── :z (variable name)
                             │      └───── nil 
                             └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'false' do
      code = <<~'CODE'
        false
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:5]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <FALSE> [1:0-1:5]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'self' do
      code = <<~'CODE'
        self
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:4]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <SELF> [1:0-1:4]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'nil' do
      code = <<~'CODE'
        nil
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <NIL> [1:0-1:3]
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'defined?' do
      code = <<~'CODE'
        defined?(FOO)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:13]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DEFINED> [1:0-1:13]
               └───── <CONST> [1:9-1:12]
                      └───── :FOO (const name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'colon2' do
      code = <<~'CODE'
        FOO::BAR
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:8]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <COLON2> [1:0-1:8]
               ├───── <CONST> [1:0-1:3]
               │      └───── :FOO (const name)
               └───── :BAR (const name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'colon3' do
      code = <<~'CODE'
        ::FOO
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:5]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <COLON3> [1:0-1:5]
               └───── :FOO (const name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dot2' do
      code = <<~'CODE'
        (1..10)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:7]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DOT2> [1:1-1:6]
               ├───── <LIT> [1:1-1:2]
               │      └───── 1 (value)
               └───── <LIT> [1:4-1:6]
                      └───── 10 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dot3' do
      code = <<~'CODE'
        (1...10)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:8]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DOT3> [1:1-1:7]
               ├───── <LIT> [1:1-1:2]
               │      └───── 1 (value)
               └───── <LIT> [1:5-1:7]
                      └───── 10 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'flip2' do
      code = <<~'CODE'
        if (x==1)..(x==5)
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <IF> [1:0-3:3]
               ├───── <FLIP2> [1:3-1:17]
               │      ├───── <OPCALL> [1:4-1:8]
               │      │      ├───── <VCALL> [1:4-1:5]
               │      │      │      └───── :x (method id)
               │      │      ├───── :== (method id)
               │      │      └───── <ARRAY> [1:7-1:8]
               │      │             ├───── <LIT> [1:7-1:8]
               │      │             │      └───── 1 (value)
               │      │             └───── nil (unknown)
               │      └───── <OPCALL> [1:12-1:16]
               │             ├───── <VCALL> [1:12-1:13]
               │             │      └───── :x (method id)
               │             ├───── :== (method id)
               │             └───── <ARRAY> [1:15-1:16]
               │                    ├───── <LIT> [1:15-1:16]
               │                    │      └───── 5 (value)
               │                    └───── nil (unknown)
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               └───── nil (else clause)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'flip3' do
      code = <<~'CODE'
        if (x==1)...(x==5)
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <IF> [1:0-3:3]
               ├───── <FLIP3> [1:3-1:18]
               │      ├───── <OPCALL> [1:4-1:8]
               │      │      ├───── <VCALL> [1:4-1:5]
               │      │      │      └───── :x (method id)
               │      │      ├───── :== (method id)
               │      │      └───── <ARRAY> [1:7-1:8]
               │      │             ├───── <LIT> [1:7-1:8]
               │      │             │      └───── 1 (value)
               │      │             └───── nil (unknown)
               │      └───── <OPCALL> [1:13-1:17]
               │             ├───── <VCALL> [1:13-1:14]
               │             │      └───── :x (method id)
               │             ├───── :== (method id)
               │             └───── <ARRAY> [1:16-1:17]
               │                    ├───── <LIT> [1:16-1:17]
               │                    │      └───── 5 (value)
               │                    └───── nil (unknown)
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               └───── nil (else clause)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'errinfo' do
      code = <<~'CODE'
        begin
        rescue => ex
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [:ex] (local table)
        ├───── nil (arguments)
        └───── <RESCUE> [1:5-2:12]
               ├───── <BEGIN> [1:5-1:5]
               │      └───── nil (body)
               ├───── <RESBODY> [2:0-2:12]
               │      ├───── nil (rescue clause list)
               │      ├───── <BLOCK> [2:7-2:12]
               │      │      ├───── <LASGN> [2:7-2:12]
               │      │      │      ├───── :ex (variable name)
               │      │      │      └───── <ERRINFO> [2:7-2:12]
               │      │      └───── <BEGIN> [2:12-2:12]
               │      │             └───── nil (body)
               │      └───── nil (next clause)
               └───── nil (next clause)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'class' do
      code = <<~'CODE'
        class Foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-2:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CLASS> [1:0-2:3]
               ├───── <COLON2> [1:6-1:9]
               │      ├───── nil (const path)
               │      └───── :Foo (const name)
               ├───── nil (super class)
               └───── <SCOPE> [1:0-2:3]
                      ├───── [] (local table)
                      ├───── nil (arguments)
                      └───── <BEGIN> [1:9-1:9]
                             └───── nil (body)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'module' do
      code = <<~'CODE'
        module Foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-2:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <MODULE> [1:0-2:3]
               ├───── <COLON2> [1:7-1:10]
               │      ├───── nil (const path)
               │      └───── :Foo (const name)
               └───── <SCOPE> [1:0-2:3]
                      ├───── [] (local table)
                      ├───── nil (arguments)
                      └───── <BEGIN> [1:10-1:10]
                             └───── nil (body)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'const decl' do
      code = <<~'CODE'
        FOO = 1
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:7]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CDECL> [1:0-1:7]
               ├───── :FOO (const name)
               └───── <LIT> [1:6-1:7]
                      └───── 1 (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'singleton class' do
      code = <<~'CODE'
        class Foo
          class << self
          end
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-4:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CLASS> [1:0-4:3]
               ├───── <COLON2> [1:6-1:9]
               │      ├───── nil (const path)
               │      └───── :Foo (const name)
               ├───── nil (super class)
               └───── <SCOPE> [1:0-4:3]
                      ├───── [] (local table)
                      ├───── nil (arguments)
                      └───── <BLOCK> [1:9-3:5]
                             ├───── <BEGIN> [1:9-1:9]
                             │      └───── nil (body)
                             └───── <SCLASS> [2:2-3:5]
                                    ├───── <SELF> [2:11-2:15]
                                    └───── <SCOPE> [2:2-3:5]
                                           ├───── [] (local table)
                                           ├───── nil (arguments)
                                           └───── <BEGIN> [2:15-2:15]
                                                  └───── nil (body)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'const' do
      code = <<~'CODE'
        FOO
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <CONST> [1:0-1:3]
               └───── :FOO (const name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'string' do
      code = <<~'CODE'
        'foo'
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:5]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <STR> [1:0-1:5]
               └───── "foo" (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dstr' do
      code = <<~'CODE'
        "foo#{bar}baz"
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:14]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DSTR> [1:0-1:14]
               ├───── "foo" (preceding string)
               ├───── <EVSTR> [1:4-1:10]
               │      └───── <VCALL> [1:6-1:9]
               │             └───── :bar (method id)
               └───── <ARRAY> [1:10-1:13]
                      ├───── <STR> [1:10-1:13]
                      │      └───── "baz" (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dstr 2' do
      code = <<~'CODE'
        "#{bar}"
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:8]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DSTR> [1:0-1:8]
               ├───── "" (preceding string)
               ├───── <EVSTR> [1:0-1:8]
               │      └───── <VCALL> [1:3-1:6]
               │             └───── :bar (method id)
               └───── nil (tailing string)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dxstr' do
      code = <<~'CODE'
        `ls #{option}`
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:14]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DXSTR> [1:0-1:14]
               ├───── "ls " (preceding string)
               ├───── <EVSTR> [1:4-1:13]
               │      └───── <VCALL> [1:6-1:12]
               │             └───── :option (method id)
               └───── nil (tailing string)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'alias' do
      code = <<~'CODE'
        alias bar foo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:13]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ALIAS> [1:0-1:13]
               ├───── <LIT> [1:6-1:9]
               │      └───── :bar (value)
               └───── <LIT> [1:10-1:13]
                      └───── :foo (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'valias' do
      code = <<~'CODE'
        alias $MATCH $&
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:15]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <VALIAS> [1:0-1:15]
               ├───── :$MATCH (new name)
               └───── :$& (old name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'undef' do
      code = <<~'CODE'
        undef foo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:9]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <UNDEF> [1:6-1:9]
               └───── <LIT> [1:6-1:9]
                      └───── :foo (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'nth_ref' do
      code = <<~'CODE'
        $1
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:2]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <NTH_REF> [1:0-1:2]
               └───── :$1 (variable name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'back_ref' do
      code = <<~'CODE'
        $&
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:2]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <BACK_REF> [1:0-1:2]
               └───── :$& (variable name)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'match' do
      code = <<~'CODE'
        if /foo/
          foo
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <IF> [1:0-3:3]
               ├───── <MATCH> [1:3-1:8]
               │      └───── /foo/ (regexp)
               ├───── <VCALL> [2:2-2:5]
               │      └───── :foo (method id)
               └───── nil (else clause)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'match2' do
      code = <<~'CODE'
        /foo/ =~ 'foo'
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:14]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <MATCH2> [1:0-1:14]
               ├───── <LIT> [1:0-1:5]
               │      └───── /foo/ (value)
               └───── <STR> [1:9-1:14]
                      └───── "foo" (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'match3' do
      code = <<~'CODE'
        'foo' =~ /foo/
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:14]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <MATCH3> [1:0-1:14]
               ├───── <LIT> [1:9-1:14]
               │      └───── /foo/ (value)
               └───── <STR> [1:0-1:5]
                      └───── "foo" (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dregx' do
      code = <<~'CODE'
        /#{bar}/
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:8]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DREGX> [1:0-1:8]
               ├───── "" (preceding string)
               ├───── <EVSTR> [1:1-1:7]
               │      └───── <VCALL> [1:3-1:6]
               │             └───── :bar (method id)
               └───── nil (tailing string)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'once' do
      code = <<~'CODE'
        /foo#{bar}baz/o
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:15]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ONCE> [1:0-1:15]
               └───── <DREGX> [1:0-1:15]
                      ├───── "foo" (preceding string)
                      ├───── <EVSTR> [1:4-1:10]
                      │      └───── <VCALL> [1:6-1:9]
                      │             └───── :bar (method id)
                      └───── <ARRAY> [1:10-1:13]
                             ├───── <STR> [1:10-1:13]
                             │      └───── "baz" (value)
                             └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'argscat' do
      code = <<~'CODE'
        foo(*ary, post_arg1, post_arg2)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:31]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <FCALL> [1:0-1:31]
               ├───── :foo (method id)
               └───── <ARGSCAT> [1:4-1:30]
                      ├───── <SPLAT> [1:4-1:8]
                      │      └───── <VCALL> [1:5-1:8]
                      │             └───── :ary (method id)
                      └───── <ARRAY> [1:10-1:30]
                             ├───── <VCALL> [1:10-1:19]
                             │      └───── :post_arg1 (method id)
                             ├───── <VCALL> [1:21-1:30]
                             │      └───── :post_arg2 (method id)
                             └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'argspush' do
      code = <<~'CODE'
        foo(*ary, post_arg)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:19]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <FCALL> [1:0-1:19]
               ├───── :foo (method id)
               └───── <ARGSPUSH> [1:4-1:18]
                      ├───── <SPLAT> [1:4-1:8]
                      │      └───── <VCALL> [1:5-1:8]
                      │             └───── :ary (method id)
                      └───── <VCALL> [1:10-1:18]
                             └───── :post_arg (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'splat' do
      code = <<~'CODE'
        foo(*ary)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:9]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <FCALL> [1:0-1:9]
               ├───── :foo (method id)
               └───── <SPLAT> [1:4-1:8]
                      └───── <VCALL> [1:5-1:8]
                             └───── :ary (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'block_pass' do
      code = <<~'CODE'
        foo(x, &blk)
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:12]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <FCALL> [1:0-1:12]
               ├───── :foo (method id)
               └───── <BLOCK_PASS> [1:4-1:11]
                      ├───── <ARRAY> [1:4-1:5]
                      │      ├───── <VCALL> [1:4-1:5]
                      │      │      └───── :x (method id)
                      │      └───── nil (unknown)
                      └───── <VCALL> [1:8-1:11]
                             └───── :blk (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'defn' do
      code = <<~'CODE'
        def foo
          bar
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DEFN> [1:0-3:3]
               ├───── :foo (method id)
               └───── <SCOPE> [1:0-3:3]
                      ├───── [] (local table)
                      ├───── <ARGS> [1:7-1:7]
                      │      ├───── 0 (pre_num)
                      │      ├───── nil (pre_init)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── <VCALL> [2:2-2:5]
                             └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'defs' do
      code = <<~'CODE'
        def obj.foo
          bar
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DEFS> [1:0-3:3]
               ├───── <VCALL> [1:4-1:7]
               │      └───── :obj (method id)
               ├───── :foo (method id)
               └───── <SCOPE> [1:0-3:3]
                      ├───── [] (local table)
                      ├───── <ARGS> [1:11-1:11]
                      │      ├───── 0 (pre_num)
                      │      ├───── nil (pre_init)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── <VCALL> [2:2-2:5]
                             └───── :bar (method id)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'sym' do
      code = <<~'CODE'
        :foo
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:4]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <LIT> [1:0-1:4]
               └───── :foo (value)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dsym' do
      code = <<~'CODE'
        :"foo#{bar}baz"
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:15]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DSYM> [1:0-1:15]
               ├───── "foo" (preceding string)
               ├───── <EVSTR> [1:5-1:11]
               │      └───── <VCALL> [1:7-1:10]
               │             └───── :bar (method id)
               └───── <ARRAY> [1:11-1:14]
                      ├───── <STR> [1:11-1:14]
                      │      └───── "baz" (value)
                      └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'dsym 2' do
      code = <<~'CODE'
        :"#{bar}"
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-1:9]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DSYM> [1:0-1:9]
               ├───── nil (preceding string)
               ├───── <EVSTR> [1:2-1:8]
               │      └───── <VCALL> [1:4-1:7]
               │             └───── :bar (method id)
               └───── nil (tailing string)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'simple call method' do
      code = <<~'CODE'
        10.times do |i|
          puts i
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-3:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <ITER> [1:0-3:3]
               ├───── <CALL> [1:0-1:8]
               │      ├───── <LIT> [1:0-1:2]
               │      │      └───── 10 (value)
               │      ├───── :times (method id)
               │      └───── nil (arguments)
               └───── <SCOPE> [1:9-3:3]
                      ├───── [:i] (local table)
                      ├───── <ARGS> [1:13-1:14]
                      │      ├───── 1 (pre_num)
                      │      ├───── nil (pre_init)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── <FCALL> [2:2-2:8]
                             ├───── :puts (method id)
                             └───── <ARRAY> [2:7-2:8]
                                    ├───── <DVAR> [2:7-2:8]
                                    │      └───── :i (variable name)
                                    └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end

    it 'nil statement' do
      code = <<~'CODE'
        def foo
          puts 'hello'
          nil
        end
      CODE

      expect = <<~'EXPECT'
        <SCOPE> [1:0-4:3]
        ├───── [] (local table)
        ├───── nil (arguments)
        └───── <DEFN> [1:0-4:3]
               ├───── :foo (method id)
               └───── <SCOPE> [1:0-4:3]
                      ├───── [] (local table)
                      ├───── <ARGS> [1:7-1:7]
                      │      ├───── 0 (pre_num)
                      │      ├───── nil (pre_init)
                      │      ├───── nil (opt)
                      │      ├───── nil (first_post)
                      │      ├───── 0 (post_num)
                      │      ├───── nil (post_init)
                      │      ├───── nil (rest)
                      │      ├───── nil (kw)
                      │      ├───── nil (kwrest)
                      │      └───── nil (block)
                      └───── <BLOCK> [2:2-3:5]
                             ├───── <FCALL> [2:2-2:14]
                             │      ├───── :puts (method id)
                             │      └───── <ARRAY> [2:7-2:14]
                             │             ├───── <STR> [2:7-2:14]
                             │             │      └───── "hello" (value)
                             │             └───── nil (unknown)
                             └───── nil (unknown)
      EXPECT

      result = ASTree.parse(code).to_s.uncolorize
      expect(result).to eq(expect)
    end
  end
end
