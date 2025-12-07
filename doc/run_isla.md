# isla

## directory structure
### 1) 核心符号执行引擎
- `isla-lib/`: **核心符号执行库**，实现Isla的核心符号执行引擎，提供与SMT求解器（Z3）的接口，包含Sail IR的解析和执行逻辑
### 2) 内存模型相关
- `isla-axiomatic/`: **公理化内存模型工具**，主要的命令行工具，用于验证并发内存模型，解析litmus测试用例，分析指令的内存访问足迹，验证处理器在并发场景下的内存一致性
- `isla-cat/`: **Cat语言翻译器**，将herd7使用的cat内存模型语言子集翻译为SMTLIB定义，支持定义各种内存一致性- 模型
- `isla-mml/`: **内存模型语言支持**，另一个内存模型语言翻译器，与isla-cat类似但可能有不同的语法支持
### 3) 格式处理和工具
- `isla-elf/`: **ELF二进制文件处理**，处理ELF格式的可执行文件，与调试信息交互（DWARF格式）
- `isla-litmus/`: **Litmus测试转换器（OCaml）**，将herd7的.litmus格式转换为TOML格式，独立的OCaml工具
- `isla-sail/`: **Sail语言转换器（OCaml）**，将Sail规范转换为Isla可执行的IR格式，需要Sail编译器支持
- `isla-sexp/`: **S-表达式处理**，过程宏，用于构建S-表达式，在符号执行中用于表示中间表达式

- `target/`: 
- `test/`: 

- `src/`: 
	- isla-footprint - 计算指令的内存访问足迹
	- isla-axiomatic - 主要的并发模型验证工具
	- isla-property - 属性验证工具
	- isla-client - 客户端工具
	- isla-execute-function - 函数执行工具
	- isla-litmus-dump - Litmus测试转储工具
	- isla-preprocess - 预处理工具

## 符号执行涉及方面
使用`isla-footprint`项目

```shell
cd workdir/isla-snapshots/
tar -xvf ./armv9p4.ir.gz

sudo apt install libz3-dev gcc-aarch64-linux-gnu
```

```shell
target/release/isla-footprint -A ../isla-snapshots/armv9p4.ir -C configs/armv9p4.toml -i "add x0, x1, #3" -s | tee isla-footprint.out
```

使用`isla-axiomatic`项目

```shell
target/release/isla-axiomatic -A ../isla-snapshots/armv8p5.ir -C configs/armv8p5.toml -m web/client/dist/aarch64.cat web/client/dist/aarch64/MP+dmb.sy+ctrl.toml | tee isla-axiomatic.out
```

