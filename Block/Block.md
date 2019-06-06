# 理解 Block 实现原理

## 一、Block 的实现

``__方法名_block_顺序号``

```
clang -rewrite-objc main.m
```

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int tempVar = 1;
        void (^blk)(void) = ^() {
            printf("Block var:%d\n", tempVar);
        };
        blk();    
    }
    return 0;
}
```

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int tempVar;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _tempVar, int flags=0) : tempVar(_tempVar) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int tempVar = __cself->tempVar; // bound by copy
  printf("Block var:%d\n", tempVar);
}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

int main(int argc, const char * argv[]) {
    /* @autoreleasepool */ { __AtAutoreleasePool __autoreleasepool; 

        int tempVar = 1;
        void (*blk)(void) = ((void (*)())&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, tempVar));
        ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
    }
    return 0;
}
```

```
void (*blk)(void) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA));
(blk->FuncPtr)(blk);
```

```
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int tempVar;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _tempVar, int flags=0) : tempVar(_tempVar) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```
```
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  int tempVar = __cself->tempVar; // bound by copy
  printf("Block var:%d\n", tempVar);
}

```
```
static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};

```

## 二、捕获变量值

### 2.1 自动变量

1. 自动变量：Block 内
2. 静态变量：作用域内可用
3. 全局变量：整个程序可用
4. 静态全局变量：当前文件可用

```
static char globalVar[] = {"globalVar"};
static char globalStaticVar[] = {"globalStaticVar"};

void catchVar() {
    int var1 = 1;
    int var2 = 2;
    static char staticVar[] = {"staticVar"};
    
    void (^blk)(void) = ^{
        printf("%d\n", var1);
        printf("%s\n", staticVar);
        printf("%s\n", globalVar);
        printf("%s\n", globalStaticVar);
    };
    blk();
}
```

```
struct __catchVar_block_impl_0 {
  struct __block_impl impl;
  struct __catchVar_block_desc_0* Desc;
  int var1;
  char (*staticVar)[10];
  __catchVar_block_impl_0(void *fp, struct __catchVar_block_desc_0 *desc, int _var1, char (*_staticVar)[10], int flags=0) : var1(_var1), staticVar(_staticVar) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __catchVar_block_func_0(struct __catchVar_block_impl_0 *__cself) {
  int var1 = __cself->var1; // bound by copy
  char (*staticVar)[10] = __cself->staticVar; // bound by copy

        printf("%d\n", var1);
        printf("%s\n", (*staticVar));
        printf("%s\n", globalVar);
        printf("%s\n", globalStaticVar);
    }

static struct __catchVar_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __catchVar_block_desc_0_DATA = { 0, sizeof(struct __catchVar_block_impl_0)};
void catchVar() {
    int var1 = 1;
    int var2 = 2;
    static char staticVar[] = {"staticVar"};

    void (*blk)(void) = ((void (*)())&__catchVar_block_impl_0((void *)__catchVar_block_func_0, &__catchVar_block_desc_0_DATA, var1, &staticVar));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
}
```

### 2.2 静态变量

```

```

```

```

### 2.3 全局变量


```

```

```

```
### 2.4 __block 变量

```
void catchBlockVar() {
    __block int blockVar = 1;
    
    void (^blk)(void) = ^{
        blockVar = 2;
        printf("%d\n", blockVar);
    };
    blk();
}
```

```
struct __Block_byref_blockVar_0 {
  void *__isa;
__Block_byref_blockVar_0 *__forwarding;
 int __flags;
 int __size;
 int blockVar;
};

struct __catchBlockVar_block_impl_0 {
  struct __block_impl impl;
  struct __catchBlockVar_block_desc_0* Desc;
  __Block_byref_blockVar_0 *blockVar; // by ref
  __catchBlockVar_block_impl_0(void *fp, struct __catchBlockVar_block_desc_0 *desc, __Block_byref_blockVar_0 *_blockVar, int flags=0) : blockVar(_blockVar->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __catchBlockVar_block_func_0(struct __catchBlockVar_block_impl_0 *__cself) {
  __Block_byref_blockVar_0 *blockVar = __cself->blockVar; // bound by ref

        (blockVar->__forwarding->blockVar) = 2;
        printf("%d\n", (blockVar->__forwarding->blockVar));
    }
static void __catchBlockVar_block_copy_0(struct __catchBlockVar_block_impl_0*dst, struct __catchBlockVar_block_impl_0*src) {_Block_object_assign((void*)&dst->blockVar, (void*)src->blockVar, 8/*BLOCK_FIELD_IS_BYREF*/);}

static void __catchBlockVar_block_dispose_0(struct __catchBlockVar_block_impl_0*src) {_Block_object_dispose((void*)src->blockVar, 8/*BLOCK_FIELD_IS_BYREF*/);}

static struct __catchBlockVar_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __catchBlockVar_block_impl_0*, struct __catchBlockVar_block_impl_0*);
  void (*dispose)(struct __catchBlockVar_block_impl_0*);
} __catchBlockVar_block_desc_0_DATA = { 0, sizeof(struct __catchBlockVar_block_impl_0), __catchBlockVar_block_copy_0, __catchBlockVar_block_dispose_0};
void catchBlockVar() {
    __attribute__((__blocks__(byref))) __Block_byref_blockVar_0 blockVar = {(void*)0,(__Block_byref_blockVar_0 *)&blockVar, 0, sizeof(__Block_byref_blockVar_0), 1};

    void (*blk)(void) = ((void (*)())&__catchBlockVar_block_impl_0((void *)__catchBlockVar_block_func_0, &__catchBlockVar_block_desc_0_DATA, (__Block_byref_blockVar_0 *)&blockVar, 570425344));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
}
```

```
// Runtime support functions used by compiler when generating copy/dispose helpers

// Values for _Block_object_assign() and _Block_object_dispose() parameters
enum {
    // see function implementation for a more complete description of these fields and combinations
    BLOCK_FIELD_IS_OBJECT   =  3,  // id, NSObject, __attribute__((NSObject)), block, ...
    BLOCK_FIELD_IS_BLOCK    =  7,  // a block variable
    BLOCK_FIELD_IS_BYREF    =  8,  // the on stack structure holding the __block variable
    BLOCK_FIELD_IS_WEAK     = 16,  // declared __weak, only used in byref copy helpers
    BLOCK_BYREF_CALLER      = 128, // called from __block (byref) copy/dispose support routines.
};
```

### 3.5 对象

```
void catchObject() {
    id obj = [NSObject new];
    
    void (^blk)(void) = ^{
        printf("%d\n", [obj hash]);
    };
    blk();
}
```

```
struct __catchObject_block_impl_0 {
  struct __block_impl impl;
  struct __catchObject_block_desc_0* Desc;
  __strong id obj;
  __catchObject_block_impl_0(void *fp, struct __catchObject_block_desc_0 *desc, __strong id _obj, int flags=0) : obj(_obj) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __catchObject_block_func_0(struct __catchObject_block_impl_0 *__cself) {
  __strong id obj = __cself->obj; // bound by copy

        printf("%d\n", ((NSUInteger (*)(id, SEL))(void *)objc_msgSend)((id)obj, sel_registerName("hash")));
    }
static void __catchObject_block_copy_0(struct __catchObject_block_impl_0*dst, struct __catchObject_block_impl_0*src) {_Block_object_assign((void*)&dst->obj, (void*)src->obj, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static void __catchObject_block_dispose_0(struct __catchObject_block_impl_0*src) {_Block_object_dispose((void*)src->obj, 3/*BLOCK_FIELD_IS_OBJECT*/);}

static struct __catchObject_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __catchObject_block_impl_0*, struct __catchObject_block_impl_0*);
  void (*dispose)(struct __catchObject_block_impl_0*);
} __catchObject_block_desc_0_DATA = { 0, sizeof(struct __catchObject_block_impl_0), __catchObject_block_copy_0, __catchObject_block_dispose_0};
void catchObject() {
    id obj = ((NSObject *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NSObject"), sel_registerName("new"));

    void (*blk)(void) = ((void (*)())&__catchObject_block_impl_0((void *)__catchObject_block_func_0, &__catchObject_block_desc_0_DATA, obj, 570425344));
    ((void (*)(__block_impl *))((__block_impl *)blk)->FuncPtr)((__block_impl *)blk);
}
```

## 三、Block 的存储域

### 3.1 _NSConcreteStackBlock

1. _NSConcreteStackBlock：栈区
2. _NSConcreteGlobalBlock：数据区域（.data 区）
3. _NSConcreteMallocBlock：堆区


```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int tempVar = 1;
        NSLog(@"Stack Block:%@\n", ^() {
            printf("Stack Block! %d\n", tempVar);
        });
    }
    return 0;
}

// printf：Stack Block:<__NSStackBlock__: 0x7ffeefbff4a0>
```


### 3.2 _NSConcreteGlobalBlock




 
```
void (^globalBlock)(void) = ^{
    printf("Global Block!\n");
};
```

```
struct __globalBlock_block_impl_0 {
  struct __block_impl impl;
  struct __globalBlock_block_desc_0* Desc;
  __globalBlock_block_impl_0(void *fp, struct __globalBlock_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteGlobalBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __globalBlock_block_func_0(struct __globalBlock_block_impl_0 *__cself) {
    printf("Global Block!\n");
}

static struct __globalBlock_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __globalBlock_block_desc_0_DATA = { 0, sizeof(struct __globalBlock_block_impl_0)};

static __globalBlock_block_impl_0 __global_globalBlock_block_impl_0((void *)__globalBlock_block_func_0, &__globalBlock_block_desc_0_DATA);
void (*globalBlock)(void) = ((void (*)())&__global_globalBlock_block_impl_0);
```

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Global Block:%@\n", ^() {
            printf("Global Block!\n");
        });
    }
    return 0;
}

// printf：Global Block:<__NSGlobalBlock__: 0x1000021c8>
```


### 3.3 _NSConcreteMallocBlock

编译器会自动处理 block 是否要拷贝到堆上

* ARC有效时 block 作为函数或方法的返回值会自动被拷贝到堆上
* Cocoa 框架中的方法名包含 usingBlock 等时
* GCD 的 API

手动操作

* 将 block 赋值给 __Strong 修饰符 id 类型对象或 Block 类型的成员变量时
* 手动调用 block 实例方法 
    * 将 block 作为方法中的参数时需要开发者手动拷贝
    * 当将 block 放入数组并作为返回值时需要手动拷贝


### 四、 __block 变量的存储域


### 五、循环引用
