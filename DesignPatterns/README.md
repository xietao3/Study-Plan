# 学习并理解 23 种设计模式

>设计模式 Design Pattern 是一套被反复使用、多数人知晓的、经过分类编目的、代码设计经验的总结，使用设计模式是为了可重用代码、让代码更容易被他人理解并且保证代码可靠性。。

在《设计模式：可复用面向对象软件的基础》一书中所介绍的 23 种经典设计模式，不过设计模式并不仅仅只有这 23 种，随着软件开发行业的发展，越来越多的新模式不断诞生并得以应用。有经验的开发者在学习设计模式可以和过往的经验互相印证，更容易理解这些设计模式。

设计模式一般包含模式名称、问题、目的、解决方案、效果等组成要素。问题描述了应该在何时使用模式，它包含了设计中存在的问题以及问题存在的原因。解决方案描述了一个设计模式的组成成分，以及这些组成成分之间的相互关系，各自的职责和协作方式，通常解决方案通过 UML 类图和核心代码来进行描述。效果描述了模式的优缺点以及在使用模式时应权衡的问题。

**为什么要学习设计模式**:

* 设计模式来源众多专家的经验和智慧，它们是从许多优秀的软件系统中总结出的成功的、能够实现可维护性复用的设计方案，使用这些方案将可以让我们避免做一些重复性的工作

* 设计模式提供了一套通用的设计词汇和一种通用的形式来方便开发人员之间沟通和交流，使得设计方案更加通俗易懂

* 大部分设计模式都兼顾了系统的可重用性和可扩展性，这使得我们可以更好地重用一些已有的设计方案、功能模块甚至一个完整的软件系统，避免我们经常做一些重复的设计、编写一些重复的代码

* 合理使用设计模式并对设计模式的使用情况进行文档化，将有助于别人更快地理解系统

* 学习设计模式将有助于初学者更加深入地理解面向对象思想

**储备知识**：

* 抽象类：一般抽象类都是作为基类，比如说「电脑」就可以作为一个抽象类，根据抽象类派生出「台式电脑」和「笔记本电脑」2种具体类。一般不对抽象类进行实例化。

* 组合优于继承：不能滥用继承来拓展功能，配合组合会更灵活。同样拿「电脑」抽象类来举例，如果使用继承，区分不同类型的「电脑」我们可以派生出「台式电脑」和「笔记本电脑」，如果再增加一个维度，根据品牌又能继续细分出「联想台式电脑」、「联想笔记本电脑」、「苹果台式电脑」和「苹果笔记本电脑」等等，如果再增加一个维度继续细分下去，显然继承是无法胜任的。这个时候可以使用继承加组合方式，组合的对象也可以进行抽象化设计：

	```
	// 品牌
	@interface Brand : NSObject
	@interface Lenovo : Brand
	@interface Apple : Brand
	
	// CPU
	@interface CPU : NSObject
	@interface Inter : CPU
	@interface AMD : CPU

	
	@interface Computer : NSObject
	// 品牌
	@property (nonatomic, strong) Brand *brand;
	// CPU
	@property (nonatomic, strong) CPU *cpu;
	@end
	
	@interface Computer : NSObject
	@interface DesktopComputer : Computer
	@interface NotebookComputer : Computer
	```

## 一、UML 类图

每个模式都有相应的对象结构图，同时为了展示对象间的交互细节， 有些时候会用到 UML 图来介绍其如何运行。这里不会将 UML 的各种元素都提到，只想讲讲类图中各个类之间的关系， 能看懂类图中各个类之间的线条、箭头代表什么意思后，也就足够应对日常的工作和交流。同时，我们应该能将类图所表达的含义和最终的代码对应起来。有了这些知识，看后面章节的设计模式结构图就没有什么问题了。

本文中大部分是 UML 类图，也有个别简易流程图。由于文中部分模式并未配图，你可以在[这里](./UML)查看我在网络上收集的完整 23 种设计模式 UML 类图。

### 1.1 继承

继承用一条带空心箭头的直接表示。

![](./src/继承.png)


### 1.2 实现

实现关系用一条带空心箭头的虚线表示。

![](./src/实现.png)


### 1.3 组合

与聚合关系一样，组合关系同样表示整体由部分构成的语义。比如公司由多个部门组成，但组合关系是一种强依赖的特殊聚合关系，如果整体不存在了，则部分也不存在了。例如，公司不存在了，部门也将不存在了。

![](./src/组合.png)

### 1.4 聚合

聚合关系用于表示实体对象之间的关系，表示整体由部分构成的语义，例如一个部门由多个员工组成。与组合关系不同的是，整体和部分不是强依赖的，即使整体不存在了，部分仍然存在。例如，部门撤销了，人员不会消失，他们依然存在。

![](./src/聚合.png)

### 1.5 关联

关联关系是用一条直线表示的，它描述不同类的对象之间的结构关系，它是一种静态关系， 通常与运行状态无关，一般由常识等因素决定的。它一般用来定义对象之间静态的、天然的结构， 所以，关联关系是一种“强关联”的关系。

比如，乘车人和车票之间就是一种关联关系，学生和学校就是一种关联关系，关联关系默认不强调方向，表示对象间相互知道。如果特别强调方向，如下图，表示 A 知道 B ，但 B 不知道 A 。

![](./src/关联.png)


### 1.6 依赖

依赖关系是用一套带箭头的虚线表示的，如A依赖于B，他描述一个对象在运行期间会用到另一个对象的关系。

与关联关系不同的是，它是一种临时性的关系，通常在运行期间产生，并且随着运行时的变化，依赖关系也可能发生变化。显然，依赖也有方向，双向依赖是一种非常糟糕的结构，我们总是应该保持单向依赖，杜绝双向依赖的产生。

![](./src/依赖.png)


## 二、六大原则

### 2.1 开闭原则

>一个软件实体应当对扩展开放，对修改关闭。即软件实体应尽量在不修改原有代码的情况下进行扩展。

任何软件都需要面临一个很重要的问题，即它们的需求会随时间的推移而发生变化。当软件系统需要面对新的需求时，我们应该尽量保证系统的设计框架是稳定的。如果一个软件设计符合开闭原则，那么可以非常方便地对系统进行扩展，而且在扩展时无须修改现有代码，使得软件系统在拥有适应性和灵活性的同时具备较好的稳定性和延续性。随着软件规模越来越大，软件寿命越来越长，软件维护成本越来越高，设计满足开闭原则的软件系统也变得越来越重要。

为了满足开闭原则，需要对系统进行抽象化设计，抽象化是开闭原则的关键。在Java、C#等编程语言中，可以为系统定义一个相对稳定的抽象层，而将不同的实现行为移至具体的实现层中完成。在很多面向对象编程语言中都提供了接口、抽象类等机制，可以通过它们定义系统的抽象层，再通过具体类来进行扩展。如果需要修改系统的行为，无须对抽象层进行任何改动，只需要增加新的具体类来实现新的业务功能即可，实现在不修改已有代码的基础上扩展系统的功能，达到开闭原则的要求。


**优点：实践开闭原则的优点在于可以在不改动原有代码的前提下给程序扩展功能。增加了程序的可扩展性，同时也降低了程序的维护成本。**


### 2.2 里氏替换原则 

>所有引用基类对象的地方能够透明地使用其子类的对象

里氏代换原则告诉我们，在软件中将一个基类对象替换成它的子类对象，程序将不会产生任何错误和异常，反过来则不成立，如果一个软件实体使用的是一个子类对象的话，那么它不一定能够使用基类对象。例如：我喜欢动物，那我一定喜欢狗，因为狗是动物的子类。但是我喜欢狗，不能据此断定我喜欢动物，因为我并不喜欢老鼠，虽然它也是动物。

例如有两个类，一个类为``BaseClass``，另一个是``SubClass``类，并且``SubClass``类是``BaseClass``类的子类，那么一个方法如果可以接受一个``BaseClass``类型的基类对象``base``的话，如：``method1(base)``，那么它必然可以接受一个``BaseClass``类型的子类对象``sub``，``method1(sub)``能够正常运行。反过来的代换不成立，如一个方法``method2``接受``BaseClass``类型的子类对象``sub``为参数：``method2(sub)``，那么一般而言不可以有``method2(base)``，除非是重载方法。

里氏代换原则是实现开闭原则的重要方式之一，由于使用基类对象的地方都可以使用子类对象，因此在程序中尽量使用基类类型来对对象进行定义，而在运行时再确定其子类类型，用子类对象来替换父类对象。

**优点：可以检验继承使用的正确性，约束继承在使用上的泛滥。**


### 2.3 依赖倒置原则 

>抽象不应该依赖于具体类，具体类应当依赖于抽象。换言之，要针对接口编程，而不是针对实现编程。

依赖倒转原则要求我们在程序代码中传递参数时或在关联关系中，尽量引用层次高的抽象层类，即使用接口和抽象类进行变量类型声明、参数类型声明、方法返回类型声明，以及数据类型的转换等，而不要用具体类来做这些事情。为了确保该原则的应用，一个具体类应当只实现接口或抽象类中声明过的方法，而不要给出多余的方法，否则将无法调用到在子类中增加的新方法。

在引入抽象层后，系统将具有很好的灵活性，在程序中尽量使用抽象层进行编程，而将具体类写在配置文件中，这样一来，如果系统行为发生变化，只需要对抽象层进行扩展，并修改配置文件，而无须修改原有系统的源代码，在不修改的情况下来扩展系统的功能，满足开闭原则的要求。

**优点：通过抽象来搭建框架，建立类和类的关联，以减少类间的耦合性。而且以抽象搭建的系统要比以具体实现搭建的系统更加稳定，扩展性更高，同时也便于维护。**

### 2.4 单一职责原则 

>一个类只负责一个功能领域中的相应职责，或者可以定义为：就一个类而言，应该只有一个引起它变化的原因。


 单一职责原则告诉我们：一个类不能太“累”！在软件系统中，一个类（大到模块，小到方法）承担的职责越多，它被复用的可能性就越小，而且一个类承担的职责过多，就相当于将这些职责耦合在一起，当其中一个职责变化时，可能会影响其他职责的运作，因此要将这些职责进行分离，将不同的职责封装在不同的类中，即将不同的变化原因封装在不同的类中，如果多个职责总是同时发生改变则可将它们封装在同一类中。

单一职责原则是实现高内聚、低耦合的指导方针，它是最简单但又最难运用的原则，需要设计人员发现类的不同职责并将其分离，而发现类的多重职责需要设计人员具有较强的分析设计能力和相关实践经验。


**优点：如果类与方法的职责划分得很清晰，不但可以提高代码的可读性，更实际性地更降低了程序出错的风险，因为清晰的代码会让 bug 无处藏身，也有利于 bug 的追踪，也就是降低了程序的维护成本。**


### 2.5 迪米特法则（最少知道原则）

>一个软件实体应当尽可能少地与其他实体发生相互作用 

如果一个系统符合迪米特法则，那么当其中某一个模块发生修改时，就会尽量少地影响其他模块，扩展会相对容易，这是对软件实体之间通信的限制，迪米特法则要求限制软件实体之间通信的宽度和深度。迪米特法则可降低系统的耦合度，使类与类之间保持松散的耦合关系。

迪米特法则要求我们在设计系统时，应该尽量减少对象之间的交互，如果两个对象之间不必彼此直接通信，那么这两个对象就不应当发生任何直接的相互作用，如果其中的一个对象需要调用另一个对象的某一个方法的话，可以通过第三者转发这个调用。简言之，就是通过引入一个合理的第三者来降低现有对象之间的耦合度。

在将迪米特法则运用到系统设计中时，要注意下面的几点：在类的划分上，应当尽量创建松耦合的类，类之间的耦合度越低，就越有利于复用，一个处在松耦合中的类一旦被修改，不会对关联的类造成太大波及。在类的结构设计上，每一个类都应当尽量降低其成员变量和成员函数的访问权限。在类的设计上，只要有可能，一个类型应当设计成不变类。在对其他类的引用上，一个对象对其他对象的引用应当降到最低。


**优点：实践迪米特法则可以良好地降低类与类之间的耦合，减少类与类之间的关联程度，让类与类之间的协作更加直接。**

### 2.6 接口分离原则

>使用多个专门的接口，而不使用单一的总接口，即客户端不应该依赖那些它不需要的接口。  

根据接口隔离原则，当一个接口太大时，我们需要将它分割成一些更细小的接口，使用该接口的客户端仅需知道与之相关的方法即可。每一个接口应该承担一种相对独立的角色，不干不该干的事，该干的事都要干。

在使用接口隔离原则时，我们需要注意控制接口的粒度，接口不能太小，如果太小会导致系统中接口泛滥，不利于维护。接口也不能太大，太大的接口将违背接口隔离原则，灵活性较差，使用起来很不方便。

**优点：避免同一个接口里面包含不同类职责的方法，接口责任划分更加明确，符合高内聚低耦合的思想。**

### 2.7 合成复用原则（六大之外的）

>尽量使用对象组合，而不是继承来达到复用的目的

  合成复用原则就是在一个新的对象里通过关联关系（包括组合关系和聚合关系）来使用一些已有的对象，使之成为新对象的一部分，新对象通过委派调用已有对象的方法达到复用功能的目的。简而言之，复用时要尽量使用组合/聚合关系（关联关系），少用继承。

在面向对象设计中，可以通过两种方法在不同的环境中复用已有的设计和实现，即通过组合/聚合关系或通过继承，但首先应该考虑使用组合/聚合，组合/聚合可以使系统更加灵活，降低类与类之间的耦合度。一个类的变化对其他类造成的影响相对较少，其次才考虑继承，在使用继承时，需要严格遵循里氏代换原则，有效使用继承会有助于对问题的理解，降低复杂度，而滥用继承反而会增加系统构建和维护的难度以及系统的复杂度，因此需要慎重使用继承复用。

**优点：避免复用时滥用继承，合理使用组合关系，增加灵活性。**

### 2.8 六大原则 - 学习心得

六大原则中，**开闭原则**、**里氏替换原则**、**依赖倒置原则** 联系比较紧密，后两者是实现开闭原则重要前提，使用中通过抽象化设计具有很好的可拓展性和可维护性。

**知道最少原则** 可以降低耦合，减少不必要的交互，主张设计接口和类要简单易使用，将复杂的逻辑封装并提供简单易用的接口。

**单一职责原则** 使项目中的类和方法根据职责细分，避免单个类负担过重。职责越多，被复用的可能性就越小或使用起来越麻烦。 

**接口分离原则** 将功能复杂的接口细分成多个特定功能的接口，只做该做的事情，降低耦合，但是细化粒度不能太细，容易导致接口过多。单一职责原则强调单个类内部根据职责细分的设计，接口分离原则强调类之间的耦合，尽量建立最小的依赖关系。


## 三、模式分类

《设计模式：可复用面向对象软件的基础》一书中设计模式有23个，它们各具特色，每个模式都为某一个可重复的设计问题提供了一套解决方案。根据它们的用途，设计模式可分为创建型(Creational)，结构型(Structural)和行为型(Behavioral)三种，其中创建型模式主要用于描述如何创建对象，结构型模式主要用于描述如何实现类或对象的组合，行为型模式主要用于描述类或对象怎样交互以及怎样分配职责。

此外，根据某个模式主要是用于处理类之间的关系还是对象之间的关系，设计模式还可以分为类模式和对象模式。我们经常将两种分类方式结合使用，如单例模式是对象创建型模式，模板方法模式是类行为型模式。

### 3.1 创建型

创建型模式(Creational Pattern)对类的实例化过程进行了抽象，能够将模块中对象的创建和对象的使用分离。为了使结构更加清晰，外界对于这些对象只需要知道它们共同的接口，而不清楚其具体的实现细节，使整个系统的设计更加符合单一职责原则。

1. 简单工厂模式（Simple Factory Pattern）
2. 工厂方法模式（Factory Method Pattern）
3. 抽象工厂模式（Abstract Factory Pattern）
4. 单例模式（Singleton Pattern）
5. 生成器模式（Builder Pattern）
6. 原型模式（Prototype Pattern）

### 3.2 结构型

结构型模式(Structural Pattern)描述如何将类或者对 象结合在一起形成更大的结构，就像搭积木，可以通过 简单积木的组合形成复杂的、功能更为强大的结构。结构型模式可以分为类结构型模式和对象结构型模式：

* 类结构型模式关心类的组合，由多个类可以组合成一个更大的系统，在类结构型模式中一般只存在继承关系和实现关系。 

* 对象结构型模式关心类与对象的组合，通过关联关系使得在一 个类中定义另一个类的实例对象，然后通过该对象调用其方法。 根据“合成复用原则”，在系统中尽量使用关联关系来替代继 承关系，因此大部分结构型模式都是对象结构型模式。


1. 外观模式
2. 适配器模式
3. 桥接模式
4. 代理模式
5. 装饰者模式
6. 享元模式

### 3.3 行为型

行为型模式(Behavioral Pattern)是对在不同的对象之间划分责任和算法的抽象化。行为型模式不仅仅关注类和对象的结构，而且重点关注它们之间的相互作用。通过行为型模式，可以更加清晰地划分类与对象的职责，并研究系统在运行时实例对象之间的交互。

1. 职责链模式
2. 命令模式
3. 解释器模式
4. 迭代器模式
5. 中介者模式
6. 备忘录模式
7. 观察者模式
8. 状态模式
9. 策略模式
10. 模板方法模式
11. 访问者模式


## 四、创建型 - 设计模式

### 4.1 简单工厂模式

>简单工厂模式(Simple Factory Pattern)：专门定义一个类（工厂类）来负责创建其他类的实例。可以根据创建方法的参数来返回不同类的实例，被创建的实例通常都具有共同的父类。

![](./src/简单工厂.png)

**举例：**

简单工厂模式像一个代工厂，一个工厂可以生产多种产品。举个例子，一个饮料加工厂同时帮百事可乐和可口可乐生产，加工厂根据输入参数``Type``来生产不同的产品。

```
// 可乐抽象类
@interface Cola : NSObject
@end

// 可口可乐产品类
@interface CocaCola : Cola
@end

// 百事可乐产品类
@interface PesiCola : Cola
@end
```

```
// 简单工厂实现
@implementation SimpleFactory

+ (Cola *)createColaWithType:(NSInteger)type {
    switch (type) {
        case 0:
            return [CocaCola new];
        case 1:
            return [PesiCola new];
        default:
            return nil;
            break;
    }
}
@end
```
```
// 0 生产可口可乐
Cola *cocaCola = [SimpleFactory createColaWithType:0];

// 1 生产百事可乐
Cola *pesiCola = [SimpleFactory createColaWithType:1];
```

**优点：**

* 使用者只需要给工厂类传入一个正确的约定好的参数，就可以获取你所需要的对象，而不需要知道其创建细节，一定程度上减少系统的耦合。
* 客户端无须知道所创建的具体产品类的类名，只需要知道具体产品类所对应的参数即可，减少开发者的记忆成本。

**缺点：**

* 如果业务上添加新产品的话，就需要修改工厂类原有的判断逻辑，这其实是违背了开闭原则的。
* 在产品类型较多时，有可能造成工厂逻辑过于复杂。所以简单工厂模式比较适合产品种类比较少而且增多的概率很低的情况。

### 4.2 工厂方法模式

>工厂方法模式(Factory Method Pattern)又称为工厂模式，工厂父类负责定义创建产品对象的公共接口，而工厂子类则负责生成具体的产品对象，即通过不同的工厂子类来创建不同的产品对象。

![](./src/工厂方法.png)

**举例：**

工厂方法和简单工厂有一些区别，简单工厂是由一个代工厂生产不同的产品，而工厂方法是对工厂进行抽象化，不同产品都由专门的具体工厂来生产。可口可乐工厂专门生产可口可乐，百事可乐工厂专门生产百事可乐。

```
// 工厂抽象类
@implementation Factory
+ (Cola *)createCola {
    return [Cola new];
}
@end

// 可口可乐工厂
@implementation CocaColaFactory

+ (Cola *)createCola {
    return [CocaCola new];
}
@end

// 百事可乐工厂
@implementation PesiColaFactory
+ (Cola *)createCola {
    return [PesiCola new];
}
@end
```

```
// 根据不同的工厂类生产不同的产品
Cola *pesiCola = [PesiColaFactory createCola];
Cola *cocaCola = [CocaColaFactory createCola];
```

**优点：**

* 用户只需要关心其所需产品对应的具体工厂是哪一个即可，不需要关心产品的创建细节，也不需要知道具体产品类的类名。
* 当系统中加入新产品时，不需要修改抽象工厂和抽象产品提供的接口，也无须修改客户端和其他的具体工厂和具体产品，而只要添加一个具体工厂和与其对应的具体产品就可以了，符合了开闭原则。

**缺点：**

* 当系统中加入新产品时，除了需要提供新的产品类之外，还要提供与其对应的具体工厂类。因此系统中类的个数将成对增加，增加了系统的复杂度。

### 4.3 抽象工厂模式

>抽象工厂模式(Abstract Factory Pattern)：提供一个创建一系列相关或相互依赖对象的接口，而无须指定它们具体的类。

![](./src/抽象工厂.png)

**举例：**

抽象工厂和工厂方法不同的地方在于，生产产品的工厂是抽象的。举例，可口可乐公司生产可乐的同时，也需要生产装可乐的瓶子和箱子，瓶子和箱子也是可口可乐专属定制的，同样百事可乐公司也会有这个需求。这个时候我们的工厂不仅仅是生产可乐饮料的工厂，还必须同时生产同一主题的瓶子和箱子，所以它是一个抽象的主题工厂，专门生产同一主题的不同商品。

```
// 可乐抽象类和派生类
@interface Cola : NSObject
@end
@interface CocaCola : Cola
@end
@interface PesiCola : Cola
@end

// 瓶子抽象类和派生类
@interface Bottle : NSObject
@end
@interface CocaColaBottle : Bottle
@end
@interface PesiColaBottle : Bottle
@end

// 箱子抽象类和派生类
@interface Box : NSObject
@end
@interface CocaColaBox : Box
@end
@interface PesiColaBox : Box
@end
```

```
// 工厂抽象类
@implementation Factory

+ (Cola *)createCola {
    return [Cola new];
}
+ (Bottle *)createBottle {
    return [Bottle new];
}
+ (Box *)createBox {
    return [Box new];
}
@end

// 可口可乐主题工厂
@implementation CocaColaFactory

+ (CocaCola *)createCola {
    return [CocaCola new];
}
+ (CocaColaBottle *)createBottle {
    return [CocaColaBottle new];
}
+ (CocaColaBox *)createBox {
    return [CocaColaBox new];
}
@end

// 百事可乐主题工厂
@implementation PesiColaFactory
+ (PesiCola *)createCola {
    return [PesiCola new];
}
+ (PesiColaBottle *)createBottle {
    return [PesiColaBottle new];
}
+ (PesiColaBox *)createBox {
    return [PesiColaBox new];
}
@end
```

```
// 可口可乐主题
Cola *cocaCola = [CocaColaFactory createCola];
Bottle *cocaColaBottle = [CocaColaFactory createBottle];
Box *cocaColaBox = [CocaColaFactory createBox];

// 百事可乐主题
Cola *pesiCola = [PesiColaFactory createCola];
Bottle *pesiColaBottle = [PesiColaFactory createBottle];
Box *pesiColaBox = [PesiColaFactory createBox];

```


**优点：**

* 具体产品在应用层代码隔离，不需要关心产品细节。只需要知道自己需要的产品是属于哪个工厂的即可 当一个产品族中的多个对象被设计成一起工作时，它能够保证客户端始终只使用同一个产品族中的对象。这对一些需要根据当前环境来决定其行为的软件系统来说，是一种非常实用的设计模式。

**缺点：**

* 规定了所有可能被创建的产品集合，产品族中扩展新的产品困难，需要修改抽象工厂的接口。

### 4.4 单例模式

>单例模式(Singleton Pattern)：单例模式确保某一个类只有一个实例，并提供一个访问它的全剧访问点。

**举例：**

单例模式下，对应类只能生成一个实例。就像一个王国只能有一个国王，一旦王国里的事务多起来，这唯一的国王也容易职责过重。

```
@implementation Singleton

+ (instancetype)shareInstance {
    static Singleton *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[Singleton alloc] init];
    });
    return shareInstance;
}

@end
```

**优点：**

* 提供了对唯一实例的受控访问。因为单例类封装了它的唯一实例，所以它可以严格控制客户怎样以及何时访问它。
* 因为该类在系统内存中只存在一个对象，所以可以节约系统资源。

**缺点：**

* 由于单例模式中没有抽象层，因此单例类很难进行扩展。
* 对于有垃圾回收系统的语言 Java，C# 来说，如果对象长时间不被利用，则可能会被回收。那么如果这个单例持有一些数据的话，在回收后重新实例化时就不复存在了。

### 4.5 生成器模式

>生成器模式(Builder Pattern)：也叫创建者模式，它将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的表示。

![](./src/建造者.png)


**举例：**

生成器模式将复杂的创建逻辑进行分割，例如生产汽车，分步骤创建安装不同的零件。如果创建逻辑简单则没有拆分的必要。

```
// 汽车生产器
@interface Builder : NSObject

+ (void)buildEngine;
+ (void)buildWheel;
+ (void)buildBody;

@end
```

```
// 创建过程进行拆分
Builder *builder = [Builder new];
[builder buildBody];
[builder buildWheel];
[builder buildEngine];
```

**优点：**

* 客户端不必知道产品内部组成的细节，将产品本身与产品的创建过程解耦，使得相同的创建过程可以创建不同的产品对象。
* 每一个具体建造者都相对独立，而与其他的具体建造者无关，因此可以很方便地替换具体建造者或增加新的具体建造者， 用户使用不同的具体建造者即可得到不同的产品对象 。
* 增加新的具体建造者无须修改原有类库的代码，指挥者类针对抽象建造者类编程，系统扩展方便，符合“开闭原则”。
* 可以更加精细地控制产品的创建过程 。将复杂产品的创建步骤分解在不同的方法中，使得创建过程更加清晰，也更方便使用程序来控制创建过程。

**缺点：**

* 建造者模式所创建的产品一般具有较多的共同点，其组成部分相似，如果产品之间的差异性很大，则不适合使用建造者模式，因此其使用范围受到一定的限制。
* 如果产品的内部变化复杂，可能会导致需要定义很多具体建造者类来实现这种变化，导致系统变得很庞大。

### 4.6 原型模式

>原型模式（Prototype Pattern）: 使用原型实例指定待创建对象的类型，并且通过复制这个原型来创建新的对象。

**举例：**

原型模式就像复印技术，根据原对象复印出一个新对象，并根据需求对新对象进行微调。

```
@interface Student : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *class;
@property (nonatomic, copy) NSString *school;

@end

```

```
// 原对象
Student *lily = [Student alloc] init];
lily.name = @"lily";
lily.age = @"13";
lily.class = @"五年一班";
lily.school = @"实现学校";

// 复制原对象
Student *tom = [lily copy];

// 在原对象基础上微调
tom.name = @"tom";

```

**优点：**

* 可以利用原型模式简化对象的创建过程，尤其是对一些创建过程繁琐，包含对象层级比较多的对象来说，使用原型模式可以节约系统资源，提高对象生成的效率。
* 可以很方便得通过改变值来生成新的对象：有些对象之间的差别可能只在于某些值的不同；用原型模式可以快速复制出新的对象并手动修改值即可。

**缺点：**

* 对象包含的所有对象都需要配备一个克隆的方法，这就使得在对象层级比较多的情况下，代码量会很大，也更加复杂。

## 五、结构型 - 设计模式

### 5.1 装饰模式

>装饰模式(Decorator Pattern) ：不改变原有对象的前提下，动态地给一个对象增加一些额外的功能。

![](./src/装饰.jpg)

**举例：**

装饰模式贴合开闭原则，在不改变原有类的情况下，对父类进行改造或新增功能。举例，定一个抽象类``Tea``，只能提供白开水，但是通过装饰类``BlackTea``装饰之后拓展了新功能，通过``BlackTea``类可以用白开水泡红茶，还可以选择加柠檬。

```
@interface Tea : NSObject

+ (instancetype)createTea;

@end

@interface BlackTea : Tea

@property (nonatomic, strong) Tea *tea;

// 加红茶
- (void)addBlackTea;
// 红茶可以加柠檬
- (void)addLemon;

@end
```

```
@implementation Tea

+ (instancetype)createTea {
    NSLog(@"add water");
    return [self new];
}

@end

@implementation BlackTea
// 先加红茶，再加水
+ (instancetype)createTea {
    return [self new];
}

- (void)addBlackTea {
    NSLog(@"add black tea");
}

- (void)addLemon {
    NSLog(@"add lemon");
}

@end
```

```
// 茶
Tea *tea = [Tea createTea]; 
// output: add water

// 红茶
BlackTea *blackTea = [BlackTea createTea];
blackTea.tea = tea
[blackTea addBlackTea];
[blackTea addLemon];
// output: 
// add black tea 
// add lemon
```

**优点：**

* 比继承更加灵活：不同于在编译期起作用的继承；装饰者模式可以在运行时扩展一个对象的功能。另外也可以通过配置文件在运行时选择不同的装饰器，从而实现不同的行为。也可以通过不同的组合，可以实现不同效果。
* 符合“开闭原则”：装饰者和被装饰者可以独立变化。用户可以根据需要增加新的装饰类，在使用时再对其进行组合，原有代码无须改变。


**缺点：**

* 装饰者模式需要创建一些具体装饰类，会增加系统的复杂度。

### 5.2 外观模式

>外观模式(Facade Pattern)：外观模式定义了一个高层接口，为子系统中的一组接口提供一个统一的接口。外观模式又称为门面模式，它是一种结构型设计模式模式。


![](./src/外观.png)


**举例：**

外观模式提供了简单明确的接口，但是在内部众多子系统功能进行整合。就像图片缓存，内部包含了涉及到其他子系统的如缓存、下载等处理，外观模式将这些复杂的逻辑都隐藏了。在``UIImageView``和``UIButton``调用的时候，你只需要调一个``setImageWithUrl:(NSString *)url``接口就可以了，达到解耦合的目的。

```
@implementation WebImage

+ (UIImage *)getImageWithUrl:(NSString *)url {
    // 查看图片是否有缓存
    id cacheImage = [ImageCaches getImageFromCacheWithUrl:url];
    if (cacheImage) {
        return cacheImage;
    }
    
    // 下载图片
    id downloadImage = [ImageDownloader downloadImageWithUrl:url];
    if (downloadImage) {
    	// 缓存图片
    	[ImageCaches cacheImage:downloadImage];
    	return downloadImage;
    }else{
    	return nil;
    }
}
@end

@implementation UIImageView + WebImage / UIButton + WebImage

- (void)setImageWithUrl:(NSString *)url {
    UIImage webImage = [WebImage getImageWithUrl:url];
    if (webImage) {
    	[self setImage:webImage];
    }
}
@end


```

```
// 使用的时候不需要关系内部缓存逻辑
UIImageView *webImage = [UIImageView new];
[webImage setImageWithUrl:@"https://imageUrl"];

UIButton *webButton = [UIButton new];
[webButton setImageWithUrl:@"https://imageUrl"];

```

**优点：**

* 实现了客户端与子系统间的解耦：客户端无需知道子系统的接口，简化了客户端调用子系统的调用过程，使得子系统使用起来更加容易。同时便于子系统的扩展和维护。
* 符合迪米特法则（最少知道原则）：子系统只需要将需要外部调用的接口暴露给外观类即可，而且他的接口则可以隐藏起来。

**缺点：**

* 违背了开闭原则：在不引入抽象外观类的情况下，增加新的子系统可能需要修改外观类或客户端的代码。

### 5.3 代理模式

>代理模式(Proxy Pattern) ：为某个对象提供一个代理，并由这个代理对象控制对原对象的访问。

![](./src/代理.png)

**举例：**

代理模式像一个房屋中介，买家只能通过中介来买房，代理具备被代理类的所有功能，就像房东有卖房功能，中介也具有卖房功能。此外代理实例还可以帮助被代理实例进行一些额外处理，比如中介可以帮助房东筛选优质买家的功能，帮助房东pass掉一些不符合条件的买家。还有消息队列也是该模式。

```
// 顾客
@interface Customer ()

@property (nonatomic, strong) Waiter *waiter;

@end

@implementation Customer

// 叫服务生
- (Waiter *)callWaiter {
    _waiter = [Waiter new];
    return _waiter;
}

// 顾客点菜
- (void)orderingFood:(NSString *)food  {
    [_waiter orderingFood:food];
}

// 顾客取消某个菜
- (void)removeFood:(NSString *)food  {
    [_waiter removeFood:food];
}

@end

// 服务生
@interface Waiter ()

@property (nonatomic, strong) NSMutableArray *cacheList;

@end

@implementation Waiter

// 记下顾客点的菜
- (void)orderingFood:(NSString *)food  {
    [self.cacheList addObject:food];
}

// 帮助顾客取消某个菜
- (void)removeFood:(NSString *)food  {
    [self.cacheList removeObject:food];
}

// 将最早点的菜推给厨师
- (void)pushToChef:(Chef *)chef {
    [chef cookFood:self.cacheList.firstObject];
    [self.cacheList removeObject:self.cacheList.firstObject];
}

@end

// 厨师
@implementation Chef

- (void)cookFood:(NSString *)food {
    NSLog(@"cook %@",food);
}

@end
```

```
// 餐厅厨师
Chef *chef = [Chef new];

// 顾客
Customer *lily = [Customer new];
// 顾客叫服务生
[lily callWaiter];
// 顾客点餐
[lily orderingFood:@"小鸡炖蘑菇"];
[lily orderingFood:@"东坡肉"];
[lily orderingFood:@"虾饺皇"];
[lily orderingFood:@"红烧大虾"];
// 顾客取消某个菜
[lily removeFood:@"东坡肉"];

// 将最早点的菜菜推给厨师去烹饪
[waiter pushToChef:chef];

```

**优点：**

* 降低系统的耦合度：代理模式能够协调调用者和被调用者，在一定程度上降低了系 统的耦合度。
* 不同类型的代理可以对客户端对目标对象的访问进行不同的控制：
    * 远程代理,使得客户端可以访问在远程机器上的对象，远程机器 可能具有更好的计算性能与处理速度，可以快速响应并处理客户端请求。
    * 虚拟代理通过使用一个小对象来代表一个大对象，可以减少系统资源的消耗，对系统进行优化并提高运行速度。
    * 保护代理可以控制客户端对真实对象的使用权限。

**缺点：**

* 由于在客户端和被代理对象之间增加了代理对象，因此可能会让客户端请求的速度变慢。

### 5.4 享元模式

>享元模式(Flyweight Pattern)：运用共享技术复用大量细粒度的对象,降低程序内存的占用,提高程序的性能。


![](./src/享元.png)

**举例：**

例如 UITableViewCell 的缓存机制，达到降低内存消耗的目的。举例，音乐服务根据收费划分出免费用户和会员用户，免费用户只能听部分免费音乐，会员用户可以听全部的音乐，并且可以下载。虽然权限上二者间有一些区别，但是他们所享受的音乐来是自于同一个音乐库，这样所有的音乐都只需要保存一份就可以了。另外如果出现音乐库里没有的音乐时，则需要新增该音乐，然后其他服务也可以享受新增的音乐，相当于享元池或缓存池的功能。

享元模式区保证共享内部状态如音乐库，而外部状态根据不同需求定制如各种访问权限，使用中不能去改变内部状态，以达到共享的目的。

```
// 音乐服务
@interface MusicService ()

// 共享的音乐库
@property (nonatomic, strong) NSArray *musicLibrary;

@end

@implementation MusicService
// 听音乐
- (void)listenToMusct:(NSString *)music {
    ...
}
// 下载音乐
- (void)downloadMusic:(NSString *)music {
    ...
}

@end

// 免费音乐服务
@interface FreeMusicService : NSObject

@property (nonatomic, strong) MusicService *musicSever;

- (void)listenFreeMusic:(NSString *)music;

@end

@implementation FreeMusicService

// 只能听免费音乐
- (void)listenToFreeMusic:(NSString *)music {
    if ([music isEqualToString:@"free"]) {
    	// 如果是免费则播放
        [self.musicSever listenMusct:music];
    }else{
    	// 如果是收费音乐，则提示用户升级 Vip
        NSLog(@"please upgrade to Vip");
    }
}

@end


// Vip 音乐服务
@interface VipMusicService : NSObject

@property (nonatomic, strong) MusicService *musicSever;

- (void)listenMusic:(NSString *)music;

- (void)downloadMusic:(NSString *)music;

@end

@implementation VipMusicService

// 可以听全部的音乐
- (void)listenToMusic:(NSString *)music {
    [self.musicSever listenMusct:music];
}

// 可以下载音乐
- (void)downloadMusic:(NSString *)music {
    [self.musicSever downloadMusic:music];
}

@end
```

```
// 新建一个基础音乐库
MusicService *musicService = [MusicService new];

// 免费服务
FreeMusicService *freeService = [FreeMusicService new];
// 收费服务
VipMusicService *vipService = [VipMusicService new];

// 共享一个音乐库
freeService.musicSever = musicService;
vipService.musicSever = musicService;

[freeService listenFreeMusic:@"免费音乐"];
[vipService listenMusic:@"全部音乐"];
```

**优点：**

* 使用享元模可以减少内存中对象的数量，使得相同对象或相似对象在内存中只保存一份，降低系统的使用内存，也可以提性能。
* 享元模式的外部状态相对独立，而且不会影响其内部状态，从而使得享元对象可以在不同的环境中被共享。

**缺点：**

* 使用享元模式需要分离出内部状态和外部状态，这使得程序的逻辑复杂化。
* 对象在缓冲池中的复用需要考虑线程问题。

### 5.5 桥接模式

>桥接模式(Simple Factory Pattern)：将抽象部分与它的实现部分分离,使它们都可以独立地变化。

![](./src/桥接.png)

**举例：**

尽管手机都有各自的不同之处，但是他们都有一个手机卡卡槽，卡槽里可以插不同运营商的卡。不管手机和卡内部如何改变，只要卡槽的行业标准没有变，就都可以正常使用。桥接模式在于将复杂的类进行分割，优先对象组合的方式，就像将手机里的手机卡抽离出去新建一个类，实现手机实例持有一个手机卡实例的组合方式。而不是通过继承来新建多个不同手机卡的手机子类。

```
// 创建手机 SIM 卡协议
@protocol SIMCardProtocol <NSObject>
// 读取 SIM 卡信息接口
- (void)getSIMInfo;

@end

// SIM 卡抽象类
@interface SIMCard : NSObject
- (void)getSIMInfo;
@end

@implementation SIMCard
- (void)getSIMInfo {}
@end

// 联通 SIM 卡
@interface UnicomSIMCard : SIMCard<SIMCardProtocol>
@end

@implementation UnicomSIMCard
- (void)getSIMInfo {
    NSLog(@"Welcome Unicom User");
}
@end

// 移动 SIM 卡
@interface MobileSIMCard : SIMCard<SIMCardProtocol>
@end

@implementation MobileSIMCard
- (void)getSIMInfo {
    NSLog(@"Welcome Mobile User");
}
@end

// 手机抽象类
@interface Phone : NSObject
// 持有 SIM 卡
@property (nonatomic, strong) SIMCard *simCard;
// 启动手机方法
- (void)launchPhone;
@end

@implementation Phone
- (void)launchPhone {
    if (self.simCard) {
        [self.simCard getSIMInfo];
    }
}
@end

// iPhone
@interface iPhone : Phone
@end

// 小米手机
@interface miPhone : Phone
@end
```

```
// 联通卡
UnicomSIMCard *unicomSim = [UnicomSIMCard new];
// 移动卡
MobileSIMCard *mobileSim = [MobileSIMCard new];

// 小米手机安装上联调卡
miPhone *mi9 = [miPhone new];
[mi9 setSimCard:unicomSim];

// iPhone 安装上移动卡
iPhone *iPhoneX = [iPhone new];
[iPhoneX setSimCard:mobileSim];

// 开机
[mi9 launchPhone];
[iPhoneX launchPhone];

```

``SIMCardProtocol ``协议相当于行业标准，所以手机卡都要遵循该协议。而各个手机生产商知道该协议，就可以直接利用该协议获得 SIM 卡内部信息。

**优点：**

* 扩展性好，符合开闭原则：将抽象与实现分离，让二者可以独立变化

**缺点：**

* 在设计之前，需要识别出两个独立变化的维度。

### 5.6 适配器模式

>适配器模式(Adapter Pattern) ：将一个接口转换成客户希望的另一个接口，使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。适配器模式的别名是包装器模式（Wrapper），是一种结构型设计模式。

![](./src/适配器.png)

**举例：**

适配器模式顾名思义，比如内地用像港版插头需要一个转接头。再比如iPhone的手机卡是特别小的 Nano 卡，把 Nano 卡拿到其他手机上不能贴合卡槽尺寸，所以我们需要加一个符合卡槽尺寸的卡套。

```
// 标准卡 尺寸协议
@protocol StandardSIMSizeProtocol <NSObject>
- (void)normalSize;
@end

// nano 卡尺寸协议
@protocol NanoSIMSizeProtocol <NSObject>
- (void)nanoSize;
@end

// 标准卡 遵循标准协议
@interface StandardSIMCard : SIMCard<StandardSIMSizeProtocol>
@end

@implementation StandardSIMCard
- (void)normalSize {}
@end

// nano 卡遵循 nano 协议
@interface NanoSIMCard : SIMCard<NanoSIMSizeProtocol>
@end

@implementation NanoSIMCard
- (void)nanoSize {}
@end

// Nano 卡套
@interface NanoAdapter : SIMCard<StandardSIMSizeProtocol>
@property (nonatomic, strong) NanoSIMCard *nanoSIMCard;
@end

@implementation NanoAdapter
- (void)normalSize {}
@end

// 
@interface OnePhone : Phone

- (void)setSimCard:(SIMCard *)simCard;

@end

@implementation OnePhone
- (void)setSimCard:(SIMCard *)simCard {
    [simCard normalSize];
}
@end
```

```
// 标准卡
StandardSIMCard *standardCard = [StandardSIMCard new];
// Nano 卡
NanoSIMCard *nanoCard = [NanoSIMCard new];

// 创建大卡槽手机 插入卡后会调用 normalSize() 方法
OnePhone *onePhone = [OnePhone new];

// 标准卡 遵循 StandardSIMSizeProtocol，协议 实现了 normalSize() 方法
[onePhone setSimCard:standardCard];

// Nano 遵循 NanoSIMSizeProtocol 协议，并没有实现了 normalSize() 方法，所以会报错
[onePhone setSimCard:nanoCard];

// 加一个 Nano 卡套
NanoAdapter *nanoAdapter = [NanoAdapter new];
// 卡套持有 Nano 卡实例，方便获取 Nano 卡信息
nanoAdapter.nanoSIMCard = nanoCard;
// 将卡套放入手机， 卡套遵循 StandardSIMSizeProtocol，实现了 normalSize() 方法
[onePhone setSimCard:nanoAdapter];
```

**优点：**

* 符合开闭原则：使用适配器而不需要改变现有类，提高类的复用性。
* 目标类和适配器类解耦，提高程序扩展性。

**缺点：**

* 增加了系统的复杂性


## 六、行为型 - 设计模式


### 6.1 职责链模式

>职责链模式(Chain of Responsibility  Pattern)：避免请求发送者与接收者耦合在一起，让多个对象都有可能接收请求，将这些对象连接成一条链，并且沿着这条链传递请求，直到有对象处理它为止。职责链模式是一种对象行为型模式。

![](./src/责任链.png)

**举例：**

职责链模式在 iOS 中有大量的应用，比如事件响应链，事件传递下来会先判断该事件是不是应该由自己处理，如果不是由自己处理则传给下一位响应者去处理，如此循环下去。需要注意的是要避免响应链循环调用造成死循环，还有当所有的响应者都无法处理时的情况。

```
// 响应者
@interface Responder : NSObject

@property (nonatomic, strong) Responder *nextResponder;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger UpperLimit;
@property (nonatomic, assign) NSUInteger LowerLimit;

- (void)respondWithCode:(NSUInteger)code;

@end

@implementation Responder

- (void)respondWithCode:(NSUInteger)code {
    if (_LowerLimit <= code && code <= _UpperLimit) {
    	// 在处理范围内 
        NSLog(@"code: %ld is %@", code, _name);
    }else if (_nextResponder){
    	// 不在处理范围则 传递给下一位响应者
        [_nextResponder respondWithCode:code];
    }else{
    	// 响应链结束
        NSLog(@"code: %ld no match responder", code);
    }
}

@end
```

```
// 建立响应链
Responder *successResponder = [Responder new];
Responder *warmingResponder = [Responder new];
Responder *httpResponder = [Responder new];
Responder *serviceResponder = [Responder new];

successResponder.nextResponder = warmingResponder;
warmingResponder.nextResponder = httpResponder;
httpResponder.nextResponder = serviceResponder;

// 设置处理范围
successResponder.LowerLimit = 200;
successResponder.UpperLimit = 299;
successResponder.name = @"success";

warmingResponder.LowerLimit = 300;
warmingResponder.UpperLimit = 399;
warmingResponder.name = @"warming";

httpResponder.LowerLimit = 400;
httpResponder.UpperLimit = 499;
httpResponder.name = @"http fail";

serviceResponder.LowerLimit = 500;
serviceResponder.UpperLimit = 599;
serviceResponder.name = @"service fail";

// 使用响应者链
[successResponder respondWithCode:200]; // code: 200 is success
[successResponder respondWithCode:310]; // code: 310 is warming
[successResponder respondWithCode:401]; // code: 401 is http fail
[successResponder respondWithCode:555]; // code: 555 is service fail
[successResponder respondWithCode:666]; // code: 666 no match responder
```


**优点：**

* 职责链模式使得一个对象无须知道是其他哪一个对象处理其请求，对象仅需知道该请求会被处理即可，接收者和发送者都没有对方的明确信息，且链中的对象不需要知道链的结构，由客户端负责链的创建，降低了系统的耦合度。
* 请求处理对象仅需维持一个指向其后继者的引用，而不需要维持它对所有的候选处理者的引用，可简化对象的相互连接。
* 在给对象分派职责时，职责链可以给我们更多的灵活性，可以通过在运行时对该链进行动态的增加或修改来增加或改变处理一个请求的职责。
* 在系统中增加一个新的具体请求处理者时无须修改原有系统的代码，只需要在客户端重新建链即可，从这一点来看是符合“开闭原则”的。

**缺点：**

* 由于一个请求没有明确的接收者，那么就不能保证它一定会被处理，该请求可能一直到链的末端都得不到处理；一个请求也可能因职责链没有被正确配置而得不到处理。
* 对于比较长的职责链，请求的处理可能涉及到多个处理对象，系统性能将受到一定影响，而且在进行代码调试时不太方便。
* 如果建链不当，可能会造成循环调用，将导致系统陷入死循环。

### 6.2 命令模式

>命令模式(Command Pattern)：将一个请求封装为一个对象，从而让我们可用不同的请求对客户进行参数化；对请求排队或者记录请求日志，以及支持可撤销的操作。命令模式是一种对象行为型模式，其别名为动作(Action)模式或事务(Transaction)模式。

![](./src/命令.png)

**举例：**

和之前代理模式中的举例有些相似，不过命令模式的本质是对命令进行封装，将发出命令的责任和执行命令的责任分割开。例如遥控器是一个调用者，不同按钮代表不同的命令，而电视是接收者。

```
// 命令 -> 按钮
@interface Command : NSObject

@property (nonatomic, assign) SEL sel;
@property (nonatomic, strong) NSObject *target;

- (void)execute;
@end

@implementation Command

- (void)execute {
    [self.target performSelector:_sel withObject:nil];
}

@end

// 调用者 -> 遥控器
@interface Controller : NSObject

// 执行命令
- (void)invokCommand:(Command *)command;
// 取消命令
- (void)cancelCommand:(Command *)command;
@end

@implementation Controller

- (void)invokCommand:(Command *)command {
    [command execute];
}

- (void)cancelCommand:(Command *)command {
}

@end

// 接收者 -> 电视
@interface TV : NSObject

- (void)turnOn;

- (void)turnOff;
@end

@implementation TV

- (void)turnOn {
    NSLog(@"trun on");
}

- (void)turnOff {
    NSLog(@"trun off");
}

@end
```

```
// 接收者
TV *tv = [TV new];

// 定义命令 可以定义一个命令抽象类然后派生出各种命令类，这里作者就偷个懒了
Command *turnOnCommand = [Command new];
turnOnCommand.sel = @selector(turnOn); // 开电视命令
turnOnCommand.target = tv;

Command *turnOffCommand = [Command new];
turnOffCommand.sel = @selector(turnOff); // 关电视命令
turnOffCommand.target = tv;

// 调用者
Controller *controller = [Controller new];

// 调用者直接调用命令，不接触接收者
[controller invokCommand:turnOnCommand]; // trun on
[controller invokCommand:turnOffCommand]; // trun off

// 在此基础上也可以拓展出取消命令 cancelCommand 等方法就不一一列举

```

**优点：**

* 降低系统的耦合度。由于请求者与接收者之间不存在直接引用，因此请求者与接收者之间实现完全解耦，相同的请求者可以对应不同的接收者，同样，相同的接收者也可以供不同的请求者使用，两者之间具有良好的独立性。
* 新的命令可以很容易地加入到系统中。由于增加新的具体命令类不会影响到其他类，因此增加新的具体命令类很容易，无须修改原有系统源代码，甚至客户类代码，满足“开闭原则”的要求。
* 可以比较容易地设计一个命令队列或宏命令（组合命令）。
* 为请求的撤销(Undo)和恢复(Redo)操作提供了一种设计和实现方案。

**缺点：**

* 使用命令模式可能会导致某些系统有过多的具体命令类。因为针对每一个对请求接收者的调用操作都需要设计一个具体命令类，因此在某些系统中可能需要提供大量的具体命令类，这将影响命令模式的使用。

### 6.3 解释器模式

>解释器模式(Interpreter Pattern)：定义一个语言的文法，并且建立一个解释器来解释该语言中的句子，这里的“语言”是指使用规定格式和语法的代码。解释器模式是一种类行为型模式。

![](./src/解释器.jpg)

**举例：**

说到解释器模式，我们的编译器，在对代码进行编译的时候也用到了该模式。我们可以直接来做一个简单的解释器，一个给机器人下发指令的解释器。

命令 | 参数 
-----|-----
direction 移动方向 |'up'  'down'  'left'  'right'
action 移动方式 | 'move'  'run'
distance 移动距离 | an integer 
表达式终结符号| ';' 

通过建立一个映射关系可以很快将指令转换成行为，例如``up run 5;`` 表示向上跑5米，而``left move 12;`` 表示向左移动12米。

**优点：**

* 易于改变和扩展文法。由于在解释器模式中使用类来表示语言的文法规则，因此可以通过继承等机制来改变或扩展文法。
* 每一条文法规则都可以表示为一个类，因此可以方便地实现一个简单的语言。
* 实现文法较为容易。在抽象语法树中每一个表达式节点类的实现方式都是相似的，这些类的代码编写都不会特别复杂，还可以通过一些工具自动生成节点类代码。
* 增加新的解释表达式较为方便。如果用户需要增加新的解释表达式只需要对应增加一个新的终结符表达式或非终结符表达式类，原有表达式类代码无须修改，符合“开闭原则”。

**缺点：**

* 对于复杂文法难以维护。在解释器模式中，每一条规则至少需要定义一个类，因此如果一个语言包含太多文法规则，类的个数将会急剧增加，导致系统难以管理和维护，此时可以考虑使用语法分析程序等方式来取代解释器模式。
* 执行效率较低。由于在解释器模式中使用了大量的循环和递归调用，因此在解释较为复杂的句子时其速度很慢，而且代码的调试过程也比较麻烦。

### 6.4 迭代器模式

>迭代器模式(Iterator Pattern)：提供一种方法来访问聚合对象，而不用暴露这个对象的内部表示，其别名为游标(Cursor)。迭代器模式是一种对象行为型模式。

![](./src/迭代器.png)

**举例：**

迭代器帮助请求方获取数据，避免直接操作数据聚合类，使数据聚合类专注存储数据。具体应用有分页等功能，分页功能的迭代器将专门负责操作分页数据，将操作逻辑和数据源分离。

```
// 数据列表
@interface List : NSObject

@property (nonatomic, strong) NSArray *list;

@end

@implementation List

- (instancetype)init
{
    self = [super init];
    if (self) {
    	// 原始数据
        _list = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    }
    return self;
}

@end

// 迭代器
@interface Iterator : NSObject

@property (nonatomic, assign) NSUInteger index;

- (NSString *)previous; // 上一个数据
- (NSString *)next; // 下一个数据
- (BOOL)isFirst; // 当前是否为第一个数据

@end

@interface Iterator ()

// 迭代器持有数据源
@property (nonatomic, strong) List *list;

@end

@implementation Iterator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [List new];
    }
    return self;
}

- (NSString *)previous {
    _index = MAX(0, _index - 1);
    return [_list.list objectAtIndex:_index];
}

- (NSString *)next {
    _index = MIN(_list.list.count-1, _index + 1);
    return [_list.list objectAtIndex:_index];
}

- (BOOL)isFirst {
    return _index == 0;
}

@end
```

```
// 使用迭代器输出数据
Iterator *iterator = [Iterator new];
NSLog(@"%@",[iterator next]); // 1
NSLog(@"%@",[iterator next]); // 2
NSLog(@"%@",[iterator next]); // 3
NSLog(@"%@",[iterator previous]); // 2

```

**优点：**

* 它支持以不同的方式遍历一个聚合对象，在同一个聚合对象上可以定义多种遍历方式。在迭代器模式中只需要用一个不同的迭代器来替换原有迭代器即可改变遍历算法，我们也可以自己定义迭代器的子类以支持新的遍历方式。
* 迭代器简化了聚合类。由于引入了迭代器，在原有的聚合对象中不需要再自行提供数据遍历等方法，这样可以简化聚合类的设计。
* 在迭代器模式中，由于引入了抽象层，增加新的聚合类和迭代器类都很方便，无须修改原有代码，满足“开闭原则”的要求。

**缺点：**

* 由于迭代器模式将存储数据和遍历数据的职责分离，增加新的聚合类需要对应增加新的迭代器类，类的个数成对增加，这在一定程度上增加了系统的复杂性。
* 抽象迭代器的设计难度较大，需要充分考虑到系统将来的扩展，例如JDK内置迭代器Iterator就无法实现逆向遍历，如果需要实现逆向遍历，只能通过其子类ListIterator等来实现，而ListIterator迭代器无法用于操作Set类型的聚合对象。在自定义迭代器时，创建一个考虑全面的抽象迭代器并不是件很容易的事情。

### 6.5 中介者模式

>中介者模式(Mediator Pattern)：用一个中介对象（中介者）来封装一系列的对象交互，中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。中介者模式又称为调停者模式，它是一种对象行为型模式。

![](./src/中介者.png)

**举例：**

中介者模式将一个网状的系统结构变成一个以中介者对象为中心的星形结构，在这个星型结构中，使用中介者对象与其他对象的一对多关系来取代原有对象之间的多对多关系。所有成员通过中介者交互，方便拓展新的成员，例如下面的例子，新增一个聊天室成员只需要新建一个成员实例，然后再在聊天室中介者那注册就可以加入聊天室了。

```
// 聊天室中介者
@interface ChatMediator : NSObject

+ (instancetype)shareMediator;
// 聊天室成员注册
- (void)registerChatMember:(ChatMember *)chatMember;
// 转发消息
- (void)forwardMsg:(NSString *)msg fromMember:(ChatMember *)fromMember;

@end

@interface ChatMediator ()

@property (nonatomic, strong) NSMutableArray *memberList; // 已注册成员列表

@end

@implementation ChatMediator

+ (instancetype)shareMediator {
    static ChatMediator *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ChatMediator alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _memberList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerChatMember:(ChatMember *)chatMember {
    [_memberList addObject:chatMember];
}

- (void)forwardMsg:(NSString *)msg fromMember:(ChatMember *)fromMember {
    [_memberList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChatMember *member = obj;
        if (member != fromMember) [member receiveMsg:msg fromMember:member];
    }];
}

@end

// 聊天室成员
@interface ChatMember : NSObject

@property (nonatomic, strong) NSString *userName; // 成员昵称
// 发送消息
- (void)sendMsg:(NSString *)msg;
// 接收消息
- (void)receiveMsg:(NSString *)msg fromMember:(ChatMember *)fromMember;

@end

@implementation ChatMember

- (void)sendMsg:(NSString *)msg {
    [[ChatMediator shareMediator] forwardMsg:msg fromMember:self];
}

- (void)receiveMsg:(NSString *)msg fromMember:(ChatMember *)fromMember {
    NSLog(@"%@ receive: %@ from %@", _userName, msg, fromMember.userName);
}

@end
```

```
// 聊天室中介者
ChatMediator *mediator = [ChatMediator shareMediator];
// 新建聊天室成员
ChatMember *lily = [ChatMember new];
ChatMember *tom = [ChatMember new];
ChatMember *jack = [ChatMember new];
// 成员在中介者处注册
[mediator registerChatMember:lily];
[mediator registerChatMember:tom];
[mediator registerChatMember:jack];
// 命名
lily.userName = @"lily";
tom.userName = @"tom";
jack.userName = @"jack";
// 发送消息
[lily sendMsg:@"hello everyone!"];
[tom sendMsg:@"hello lily!"];
[jack sendMsg:@"hi tom!"];

输出：
tom receive: hello everyone! from lily
jack receive: hello everyone! from lily
lily receive: hello lily! from tom
jack receive: hello lily! from tom
lily receive: hi tom! from jack
tom receive: hi tom! from jack
```

**优点：**

* 中介者模式简化了对象之间的交互，它用中介者和同事的一对多交互代替了原来同事之间的多对多交互，一对多关系更容易理解、维护和扩展，将原本难以理解的网状结构转换成相对简单的星型结构。
* 中介者模式可将各同事对象解耦。中介者有利于各同事之间的松耦合，我们可以独立的改变和复用每一个同事和中介者，增加新的中介者和新的同事类都比较方便，更好地符合“开闭原则”。
* 可以减少子类生成，中介者将原本分布于多个对象间的行为集中在一起，改变这些行为只需生成新的中介者子类即可，这使各个同事类可被重用，无须对同事类进行扩展。

**缺点：**

* 在具体中介者类中包含了大量同事之间的交互细节，可能会导致具体中介者类非常复杂，使得系统难以维护。

### 6.6 备忘录模式

>备忘录模式(Memento Pattern)：在不破坏封装的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态，这样可以在以后将对象恢复到原先保存的状态。它是一种对象行为型模式，其别名为Token。

**举例：**

备忘录模式提供了一种状态恢复的实现机制，使得用户可以方便地回到一个特定的历史步骤，当新的状态无效或者存在问题时，可以使用暂时存储起来的备忘录将状态复原，当前很多软件都提供了撤销操作，其中就使用了备忘录模式。

我们用一个简单的游戏存档来举例，这也是备忘录模式的一种应用。

```
// 角色状态
@interface PlayerState : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) NSUInteger rank;

@end

@implementation PlayerState@end

// 角色类
@interface Player : NSObject

@property (nonatomic, strong) PlayerState *state; // 角色状态

// 设置角色状态
- (void)setPlayerName:(NSString *)name level:(NSUInteger)level rank:(NSUInteger)rank;

@end

@implementation Player
- (void)setPlayerName:(NSString *)name level:(NSUInteger)level rank:(NSUInteger)rank {
    if (!_state) _state = [PlayerState new];
    _state.name = name;
    _state.level = level;
    _state.rank = rank;
}
@end

// 备忘录
@interface Memorandum : NSObject

// 存储
- (void)storeWithPlayer:(Player *)player;
// 恢复
- (void)restoreWithPlayer:(Player *)player;

@end


@interface Memorandum ()

@property (nonatomic, strong) PlayerState *state; // 备忘录存储的角色状态

@end

@implementation Memorandum

- (void)storeWithPlayer:(Player *)player {
    _state = player.state;
}

- (void)restoreWithPlayer:(Player *)player {
    if(_state) player.state = _state;
}

@end
```

```
// 创建角色 A
Player *playA = [Player new];
[playA setPlayerName:@"King" level:99 rank:30];

// 创建备忘录并保存角色 A 的状态
Memorandum *memorandum = [Memorandum new];
[memorandum storeWithPlayer:playA];

// 创建角色 B 并使用备忘录恢复状态
Player *playB = [Player new];
[memorandum restoreWithPlayer:playB];
NSLog(@"name:%@ level:%ld rank:%ld", playB.state.name, playB.state.level, playB.state.rank);

输出：name:King level:99 rank:30

```

**优点：**

* 它提供了一种状态恢复的实现机制，使得用户可以方便地回到一个特定的历史步骤，当新的状态无效或者存在问题时，可以使用暂时存储起来的备忘录将状态复原。
* 备忘录实现了对信息的封装，一个备忘录对象是一种原发器对象状态的表示，不会被其他代码所改动。备忘录保存了原发器的状态，采用列表、堆栈等集合来存储备忘录对象可以实现多次撤销操作。

**缺点：**

* 资源消耗过大，如果需要保存的原发器类的成员变量太多，就不可避免需要占用大量的存储空间，每保存一次对象的状态都需要消耗一定的系统资源。

### 6.7 观察者模式

>观察者模式(Observer Pattern)：定义对象之间的一种一对多依赖关系，使得每当一个对象状态发生改变时，其相关依赖对象皆得到通知并被自动更新。观察者模式的别名包括发布-订阅（Publish/Subscribe）模式、模型-视图（Model/View）模式、源-监听器（Source/Listener）模式或从属者（Dependents）模式。观察者模式是一种对象行为型模式。

![](./src/观察者.png)

**举例：**

观察者模式是使用频率最高的设计模式之一，它用于建立一种对象与对象之间的依赖关系，一个对象发生改变时将自动通知其他对象，其他对象将相应作出反应。

在 iOS 中，观察者模式经常使用到，下面我就用 KVO 实现了一个通过气象台观察天气变化的简单例子。

```
// 观察目标 - 气象站
@interface WeatherStation : NSObject

@property (nonatomic, strong) NSString *state; // 天气状态

// 观察者注册方法
- (void)registerWithObserver:(Observer *)observer;

@end

@interface WeatherStation ()

@property (nonatomic, strong) NSMutableArray *observerList;

@end

@implementation WeatherStation

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"state"];
}

// 目标状态改变监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *state = change[@"new"];
    [_observerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Observer *ob = obj;
        [ob observeWeather:state];
    }];
}

// 观察者注册方法
- (void)registerWithObserver:(Observer *)observer {
    if (!_observerList) _observerList = [NSMutableArray new];
    [_observerList addObject:observer];
}

@end

// 观察者
@interface Observer : NSObject

@property (nonatomic, strong) NSString *name; // 观察者名字
// 被通知方法
- (void)observeWeather:(NSString *)weather;

@end

@implementation Observer

- (void)observeWeather:(NSString *)weather {
    NSLog(@"%@ observe weather changed: %@", _name, weather);
}

@end
```

```
// 新建监听目标 - 气象站
WeatherStation *station = [WeatherStation new];
// 新建监听者
Observer *farmer = [Observer new];
Observer *student = [Observer new];
farmer.name = @"farmer";
student.name = @"student";

// 监听者注册
[station registerWithObserver:farmer];
[station registerWithObserver:student];

// 改变状态
station.state = @"rainy";
station.state = @"sunny";

输出：
farmer observe weather changed: rainy
student observe weather changed: rainy
farmer observe weather changed: sunny
student observe weather changed: sunny
```


**优点：**

* 观察者模式可以实现表示层和数据逻辑层的分离，定义了稳定的消息更新传递机制，并抽象了更新接口，使得可以有各种各样不同的表示层充当具体观察者角色。
* 观察者模式在观察目标和观察者之间建立一个抽象的耦合。观察目标只需要维持一个抽象观察者的集合，无须了解其具体观察者。由于观察目标和观察者没有紧密地耦合在一起，因此它们可以属于不同的抽象化层次。
* 观察者模式支持广播通信，观察目标会向所有已注册的观察者对象发送通知，简化了一对多系统设计的难度。
* 观察者模式满足“开闭原则”的要求，增加新的具体观察者无须修改原有系统代码，在具体观察者与观察目标之间不存在关联关系的情况下，增加新的观察目标也很方便。

**缺点：**

* 如果一个观察目标对象有很多直接和间接观察者，将所有的观察者都通知到会花费很多时间。
* 如果在观察者和观察目标之间存在循环依赖，观察目标会触发它们之间进行循环调用，可能导致系统崩溃。
* 观察者模式没有相应的机制让观察者知道所观察的目标对象是怎么发生变化的，而仅仅只是知道观察目标发生了变化。

### 6.8 状态模式

>状态模式(State Pattern)：允许一个对象在其内部状态改变时改变它的行为，对象看起来似乎修改了它的类。其别名为状态对象(Objects for States)，状态模式是一种对象行为型模式。

![](./src/状态.png)

**举例：**

状态模式用于解决复杂对象的状态转换以及不同状态下行为的封装问题。当系统中某个对象存在多个状态，这些状态之间可以进行转换，所以对象在不同状态下具有不同行为时可以使用状态模式。状态模式将一个对象的状态从该对象中分离出来，封装到专门的状态类中，使得对象状态可以灵活变化。

我们可以做一个简单的例子，我设计了一个银行账户系统，根据存钱余额来自动设置账户的状态，银行账户在不同状态下，进行存钱、取钱和借钱的行为。在不同状态下，这些行为得到的回复也不一样，比如说没有余额时无法取钱，只能借钱。

```
// 账户状态抽象类
@interface State : NSObject
// 存钱
- (BOOL)saveMoney:(float)money;
// 取钱
- (BOOL)drawMoney:(float)money;
// 借钱
- (BOOL)borrowMoney:(float)money;

@end

@implementation State

- (BOOL)saveMoney:(float)money {
    return NO;
}

- (BOOL)drawMoney:(float)money {
   return NO;
}

- (BOOL)borrowMoney:(float)money {
   return NO;
}

@end

// 存款富余状态
@interface RichState : State
@end

@implementation RichState
// 存钱
- (BOOL)saveMoney:(float)money {
    NSLog(@"欢迎存钱 %.2f", money);
    return YES;
}
// 取钱
- (BOOL)drawMoney:(float)money {
    NSLog(@"欢迎取钱 %.2f", money);
    return YES;
}
// 借钱
- (BOOL)borrowMoney:(float)money {
    NSLog(@"您还有余额，请先花完余额");
    return NO;
}

@end

// 零存款零负债状态
@interface ZeroState : State
@end

@implementation ZeroState
// 存钱
- (BOOL)saveMoney:(float)money {
    NSLog(@"欢迎存钱 %.2f", money);
    return YES;
}
// 取钱
- (BOOL)drawMoney:(float)money {
    NSLog(@"您当前没有余额");
    return NO;
}
// 借钱
- (BOOL)borrowMoney:(float)money {
    NSLog(@"欢迎借钱 %.2f", money);
    return YES;
}

@end

// 负债状态
@interface DebtState : State
@end

@implementation DebtState
// 存钱
- (BOOL)saveMoney:(float)money {
    NSLog(@"欢迎还钱 %.2f", money);
    return YES;
}
// 取钱
- (BOOL)drawMoney:(float)money {
    NSLog(@"您当前没有余额");
    return NO;
}
// 借钱
- (BOOL)borrowMoney:(float)money {
    NSLog(@"上次欠的账还没有还清，暂时无法借钱");
    return NO;
}

@end

// 银行账户类
@interface Account : NSObject
// 存钱
- (void)saveMoney:(float)money;
// 取钱
- (void)drawMoney:(float)money;
// 借钱
- (void)borrowMoney:(float)money;

@end

@interface Account ()

@property (nonatomic, assign) float money; // 余额
@property (nonatomic, strong) State *state; // 账户状态

@end

@implementation Account

// 初始化账户
- (instancetype)init
{
    self = [super init];
    if (self) {
        _money = 0;
        _state = [ZeroState new];
    }
    return self;
}

// 存钱
- (void)saveMoney:(float)money {
    if ([_state saveMoney:money]) {
        _money += money;
        [self updateState];
    }
    NSLog(@"余额：%.2f", _money);
}
// 取钱
- (void)drawMoney:(float)money {
    if ([_state drawMoney:money]) {
        _money -= money;
        [self updateState];
    }
    NSLog(@"余额：%.2f", _money);
}
// 借钱
- (void)borrowMoney:(float)money {
    if ([_state borrowMoney:money]) {
        _money -= money;
        [self updateState];
    }
    NSLog(@"余额：%.2f", _money);
}

// 更新账户状态
- (void)updateState {
    if (_money > 0) {
        _state = [RichState new];
    }else if (_money == 0) {
        _state = [ZeroState new];
    }else{
        _state = [DebtState new];
    }
}

@end
```

```
// 初始化银行账户
Account *bankAccount = [Account new];
// 取 50
[bankAccount drawMoney:50]; // 余额：0 您当前没有余额
// 存 100
[bankAccount saveMoney:100]; // 余额：0 欢迎存钱 100.00
// 借 100
[bankAccount borrowMoney:100]; // 余额：100 您还有余额，请先花完余额
// 取 100
[bankAccount drawMoney:100]; // 余额：100 欢迎取钱 100.00
// 借 100
[bankAccount borrowMoney:100]; // 余额：0 欢迎借钱 100.00
// 借 50
[bankAccount borrowMoney:50]; // 余额：-100 上次欠的账还没有还清，暂时无法借钱
```

**优点：**

* 封装了状态的转换规则，在状态模式中可以将状态的转换代码封装在环境类或者具体状态类中，可以对状态转换代码进行集中管理，而不是分散在一个个业务方法中。
* 将所有与某个状态有关的行为放到一个类中，只需要注入一个不同的状态对象即可使环境对象拥有不同的行为。
* 允许状态转换逻辑与状态对象合成一体，而不是提供一个巨大的条件语句块，状态模式可以让我们避免使用庞大的条件语句来将业务方法和状态转换代码交织在一起。
* 可以让多个环境对象共享一个状态对象，从而减少系统中对象的个数。

**缺点：**

* 状态模式的使用必然会增加系统中类和对象的个数，导致系统运行开销增大。
* 状态模式的结构与实现都较为复杂，如果使用不当将导致程序结构和代码的混乱，增加系统设计的难度。
* 状态模式对“开闭原则”的支持并不太好，增加新的状态类需要修改那些负责状态转换的源代码，否则无法转换到新增状态；而且修改某个状态类的行为也需修改对应类的源代码。

### 6.9 策略模式

>策略模式(Strategy Pattern)：定义一系列算法类，将每一个算法封装起来，并让它们可以相互替换，策略模式让算法独立于使用它的客户而变化，也称为政策模式(Policy)。策略模式是一种对象行为型模式。

![](./src/策略.png)

**举例：**

使用策略模式时，我们可以定义一些策略类，每一个策略类中封装一种具体的算法。在这里，每一个封装算法的类我们都可以称之为一种策略，根据传入不同的策略类，使环境类执行不同策略类中的算法。

生活中也有很多类似的例子，就比如说商城的会员卡机制。我们去商城购物可以通过持有的会员卡打折，购买同一件商品时，持有不同等级的会员卡，能得到不同力度的折扣。下面的例子中我列举了青铜、白银、黄金三种 Vip 会员卡，传入不同的会员卡最终需要支付的金额也会有所不同。

```
// Vip  - 销售策略抽象类
@interface Vip : NSObject

// vip 折扣
- (float)getDiscount;
// vip 所需邮费
- (float)getPostage;
// 根据折扣和邮费计算价格
- (float)calcPrice:(float)price;

@end

@implementation Vip

- (float)getDiscount {
    return 1;
}

- (float)getPostage {
    return 20;
}

- (float)calcPrice:(float)price {
    float payPrice = price*[self getDiscount] + [self getPostage];
    return payPrice;
}

@end

// 青铜 vip - 具体策略类
@interface BronzeVip : Vip
@end

@implementation BronzeVip

- (float)getDiscount {
    return 0.9;
}

- (float)getPostage {
    return 20;
}

@end

// 白银 vip
@interface SilverVip : Vip
@end

@implementation SilverVip

- (float)getDiscount {
    return 0.7;
}

- (float)getPostage {
    return 10;
}

@end

// 黄金 vip
@interface GoldVip : Vip
@end

@implementation GoldVip

- (float)getDiscount {
    return 0.5;
}

- (float)getPostage {
    return 0;
}

@end

// 线上商城 - 环境类
@interface OnlineShop : NSObject

// 购买商品 传入持有的 vip 卡
- (void)buyProductWithVip:(Vip *)vip;

@end

@implementation OnlineShop

- (void)buyProductWithVip:(Vip *)vip {
    float productPrice = 100;
    float payPrice = [vip calcPrice:productPrice];
    NSLog(@"pay: %f", payPrice);
}

@end
```

```
// 初始化商城类
OnlineShop *shop = [OnlineShop new];
// 新建各种 vip
GoldVip *goldVip = [GoldVip new];
SilverVip *silverVip = [SilverVip new];
BronzeVip *bronzeVip = [BronzeVip new];

// 使用青铜 vip 购买 100 元的商品
[shop buyProductWithVip:bronzeVip]; // 9折+20运费 pay: 110.00
// 使用白银 vip 购买 100 元的商品
[shop buyProductWithVip:silverVip]; // 7折+10运费 pay: 80.00
// 使用黄金 vip 购买 100 元的商品
[shop buyProductWithVip:goldVip]; // 5折+ 0运费 pay: 50.00

```

**优点：**

* 策略模式提供了对“开闭原则”的完美支持，用户可以在不修改原有系统的基础上选择算法或行为，也可以灵活地增加新的算法或行为。
* 策略模式提供了管理相关的算法族的办法。策略类的等级结构定义了一个算法或行为族，恰当使用继承可以把公共的代码移到抽象策略类中，从而避免重复的代码。
* 策略模式提供了一种可以替换继承关系的办法。如果不使用策略模式，那么使用算法的环境类就可能会有一些子类，每一个子类提供一种不同的算法。但是，这样一来算法的使用就和算法本身混在一起，不符合“单一职责原则”，决定使用哪一种算法的逻辑和该算法本身混合在一起，从而不可能再独立演化；而且使用继承无法实现算法或行为在程序运行时的动态切换。
* 使用策略模式可以避免多重条件选择语句。多重条件选择语句不易维护，它把采取哪一种算法或行为的逻辑与算法或行为本身的实现逻辑混合在一起，将它们全部硬编码(Hard Coding)在一个庞大的多重条件选择语句中，比直接继承环境类的办法还要原始和落后。
* 策略模式提供了一种算法的复用机制，由于将算法单独提取出来封装在策略类中，因此不同的环境类可以方便地复用这些策略类。

**缺点：**

* 客户端必须知道所有的策略类，并自行决定使用哪一个策略类。这就意味着客户端必须理解这些算法的区别，以便适时选择恰当的算法。换言之，策略模式只适用于客户端知道所有的算法或行为的情况。
* 策略模式将造成系统产生很多具体策略类，任何细小的变化都将导致系统要增加一个新的具体策略类。
* 无法同时在客户端使用多个策略类，也就是说，在使用策略模式时，客户端每次只能使用一个策略类，不支持使用一个策略类完成部分功能后再使用另一个策略类来完成剩余功能的情况。

### 6.10 模板方法模式

>模板方法模式：定义一个操作中算法的框架，而将一些步骤延迟到子类中。模板方法模式使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。

![](./src/模板.png)

**举例：**

模板方法模式在 iOS 中的应用也非常多，如 UIViewController 的生命周期函数，定义在父类，子类可以重写这些函数。

模板方法模式具体应用又分为三类：

* 抽象方法：一个抽象方法由抽象类声明、由其具体子类实现。

* 具体方法：一个具体方法由一个抽象类或具体类声明并实现，其子类可以进行覆盖也可以直接继承。

* 钩子方法：一个钩子方法由一个抽象类或具体类声明并实现，而其子类可能会加以扩展。通常在父类中给出的实现是一个空实现，并以该空实现作为方法的默认实现，当然钩子方法也可以提供一个非空的默认实现。通过在子类中实现的钩子方法对父类方法的执行进行约束，实现子类对父类行为的反向控制。

下面给出一个例子，在给定一个有固定模板的烹饪教程的情况下，根据不同烹饪需求对教程中的内容进行动态调整。

```
// 烹饪教程 模板方法类
@interface CookTutorial : NSObject

// 烹饪食物 - 具体方法
- (void)cook;
// 准备食材 - 抽象方法
- (void)prepareIngredients;
// 加食用油 具体方法
- (void)addFat;
// 加入食材 - 抽象方法
- (void)addIngredients;
// 加入调味品 - 具体方法
- (void)addFlavouring;
// 是否为健康食物 - 钩子方法
- (BOOL)isHealthyFood;

@end

@implementation CookTutorial

- (void)cook {
    [self prepareIngredients];
    // 如果是健康食物不加食用油
    if (![self isHealthyFood]) {
        [self addFat];
    }
    [self addIngredients];
    [self addFlavouring];
}

// 抽象方法
- (void)prepareIngredients {}

// 具体方法
- (void)addFat {
    NSLog(@"2. 加调和油");
}

// 抽象方法
- (void)addIngredients {}

// 具体方法
- (void)addFlavouring {
    NSLog(@"4. 加盐");
}

//  钩子方法
- (BOOL)isHealthyFood {
    return NO;
}

@end

// 烹饪 🐟 - 模板方法子类
@interface CookFish : CookTutorial
@end

@implementation CookFish

// 准备食材
- (void)prepareIngredients {
    NSLog(@"1. 准备好生鳕鱼");
}

// 加入食材
- (void)addIngredients {
    NSLog(@"3. 生鳕鱼入锅");
}

// 加入调味品
- (void)addFlavouring {
    [super addFlavouring];
    NSLog(@"4. 加黑胡椒");
}

// 是否为健康食物（不放油）
- (BOOL)isHealthyFood {
    return YES;
}

@end
```

```
CookFish * cookFish = [CookFish new];
[cookFish cook]; 
输出：
1. 准备好生鳕鱼
3. 生鳕鱼入锅
4. 加盐
4. 加黑胡椒
```
* 第一个步骤``prepareIngredients``， 父类中没有具体实现为抽象方法，子类中直接覆盖。
* 第二个步骤加食用油方法``addFat``被钩子方法``isHealthyFood ``给跳过了。
* 第三步``addIngredients ``在父类中同样是抽象方法，子类直接覆盖。
* 第四步``addFlavouring ``在父类中有具体实现，子类继承父类的「加盐操作」后又增加了新的「加黑胡椒」操作。

**优点：**

* 在父类中形式化地定义一个算法，而由它的子类来实现细节的处理，在子类实现详细的处理算法时并不会改变算法中步骤的执行次序。
* 模板方法模式是一种代码复用技术，它在类库设计中尤为重要，它提取了类库中的公共行为，将公共行为放在父类中，而通过其子类来实现不同的行为，它鼓励我们恰当使用继承来实现代码复用。
* 可实现一种反向控制结构，通过子类覆盖父类的钩子方法来决定某一特定步骤是否需要执行。
* 在模板方法模式中可以通过子类来覆盖父类的基本方法，不同的子类可以提供基本方法的不同实现，更换和增加新的子类很方便，符合单一职责原则和开闭原则。

**缺点：**

* 需要为每一个基本方法的不同实现提供一个子类，如果父类中可变的基本方法太多，将会导致类的个数增加，系统更加庞大，设计也更加抽象，此时，可结合桥接模式来进行设计。

### 6.11 访问者模式

>访问者模式(Visitor Pattern):提供一个作用于某对象结构中的各元素的操作表示，它使我们可以在不改变各元素的类的前提下定义作用于这些元素的新操作。访问者模式是一种对象行为型模式。

![](./src/访问者.png)

**举例：**

访问者模式是一种较为复杂的行为型设计模式，它包含访问者和被访问元素两个主要组成部分，这些被访问的元素通常具有不同的类型，且不同的访问者可以对它们进行不同的访问操作。访问者模式使得用户可以在不修改现有系统的情况下扩展系统的功能，为这些不同类型的元素增加新的操作。

在使用访问者模式时，被访问元素通常不是单独存在的，它们存储在一个集合中，这个集合被称为「对象结构」，访问者通过遍历对象结构实现对其中存储的元素的逐个操作。通过一个简单的例子了解访问者模式，访问者有财务部门``FADepartment``和 HR 部门``HRDepartment``，通过访问雇员``Employee``来查看雇员的工作情况。

```
// 部门抽象类 - 访问者抽象类
@interface Department : NSObject
// 访问抽象方法 用来声明方法
- (void)visitEmployee:(Employee *)employee;

@end

@implementation Department

- (void)visitEmployee:(Employee *)employee {}

@end

// 财务部门 - 具体访问者类
@interface FADepartment : Department
@end

@implementation FADepartment
// 访问具体方法
- (void)visitEmployee:(Employee *)employee {
    if (employee.workTime > 40) {
        NSLog(@"%@ 工作时间满 40 小时", employee.name);
    }else{
        NSLog(@"%@ 工作时间不满 40 小时，要警告！", employee.name);
    }
}

@end

// HR 部门 - 具体访问者类
@interface HRDepartment : Department
@end

@implementation HRDepartment
// 访问具体方法
- (void)visitEmployee:(Employee *)employee {
    NSUInteger weekSalary = employee.workTime * employee.salary;
    NSLog(@"%@ 本周获取薪资：%ld",employee.name , weekSalary);
}

@end

// 抽象雇员类 - 被访问者抽象类
@interface Employee : NSObject
// 姓名
@property (nonatomic, strong) NSString *name;
// 工作时间
@property (nonatomic, assign) NSUInteger workTime;
// 时薪
@property (nonatomic, assign) NSUInteger salary;
// 接受访问抽象方法
- (void)accept:(Department *)department;

@end

@implementation Employee

- (void)accept:(Department *)department {}

@end

// 雇员具体类 - 被访问者具体类
@interface FulltimeEmployee : Employee

@end

@implementation FulltimeEmployee
// 接受访问具体方法
- (void)accept:(Department *)department {
    [department visitEmployee:self];
}

@end
```

```
// 新建财务和 HR - 访问者
FADepartment *fa = [FADepartment new];
HRDepartment *hr = [HRDepartment new];

// 新建雇员 - 被访问者
FulltimeEmployee *tim = [FulltimeEmployee new];
tim.name = @"tim";
tim.workTime = 55;
tim.salary = 100;

FulltimeEmployee *bill = [FulltimeEmployee new];
bill.name = @"bill";
bill.workTime = 38;
bill.salary = 150;

// 一般被访问者都存储在数据集合中方便遍历，集合中可以存储不同类型的被访问者
NSArray *employeeList = @[tim, bill];
[employeeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    Employee *employee = obj;
    // 接受财务访问
    [employee accept:fa];
    // 接受 HR 访问
    [employee accept:hr];
}];

输出：
tim 工作时间满 40 小时
tim 本周获取薪资：5500
bill 工作时间不满 40 小时，要警告！
bill 本周获取薪资：5700
```


**优点：**

* 增加新的访问操作很方便。使用访问者模式，增加新的访问操作就意味着增加一个新的具体访问者类，实现简单，无须修改源代码，符合“开闭原则”。
* 将有关元素对象的访问行为集中到一个访问者对象中，而不是分散在一个个的元素类中。类的职责更加清晰，有利于对象结构中元素对象的复用，相同的对象结构可以供多个不同的访问者访问。
* 让用户能够在不修改现有元素类层次结构的情况下，定义作用于该层次结构的操作。

**缺点：**

* 增加新的元素类很困难。在访问者模式中，每增加一个新的元素类都意味着要在抽象访问者角色中增加一个新的抽象操作，并在每一个具体访问者类中增加相应的具体操作，这违背了“开闭原则”的要求。
* 破坏封装。访问者模式要求访问者对象访问并调用每一个元素对象的操作，这意味着元素对象有时候必须暴露一些自己的内部操作和内部状态，否则无法供访问者访问。


# 总结

系统地学习设计模式后，你可以在过往的开发经历中发现，设计模式是无处不在的。在学习设计模式之前的很多时候我们是凭借过往经验和智慧来完善系统的设计，而这些经验很多和某个设计模式的思想不谋而合。

还有一些地方没有完全理解，文中有误之处还望不吝指出。

# 参考


* [https://juejin.im/user/57f8ffda2e958a005581e3c0/posts](https://juejin.im/user/57f8ffda2e958a005581e3c0/posts)
* [https://design-patterns.readthedocs.io/zh_CN/latest/index.html](https://design-patterns.readthedocs.io/zh_CN/latest/index.html)
* [https://blog.csdn.net/lovelion/article/details/17517213](https://blog.csdn.net/lovelion/article/details/17517213)
* [https://github.com/skyming/Trip-to-iOS-Design-Patterns](https://github.com/skyming/Trip-to-iOS-Design-Patterns)