#import "AppDelegate.h"

@interface AppDelegate () <UITextViewDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *scoreField;
@property (nonatomic, strong) UITextView *problemView;
@property (nonatomic, strong) UISegmentedControl *homeworkControl;
@property (nonatomic, strong) UISegmentedControl *attitudeControl;
@property (nonatomic, strong) UILabel *scoreHintLabel;
@property (nonatomic, strong) UILabel *groupLabel;
@property (nonatomic, strong) UILabel *groupGoalLabel;
@property (nonatomic, strong) UILabel *weeklyGoalLabel;
@property (nonatomic, strong) UIStackView *tasksStack;
@property (nonatomic, strong) UILabel *supervisionLabel;
@property (nonatomic, strong) UILabel *feedbackLabel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [[UIViewController alloc] init];
  rootViewController.view.backgroundColor = [self colorWithHex:0xF3F6FB];
  self.window.rootViewController = rootViewController;

  [self buildLearningHelperInView:rootViewController.view];
  [self updateLearningPlan];

  [self.window makeKeyAndVisible];
  return YES;
}

- (void)buildLearningHelperInView:(UIView *)view
{
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [view addSubview:scrollView];

  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [scrollView addSubview:contentView];

  UIStackView *stack = [[UIStackView alloc] init];
  stack.axis = UILayoutConstraintAxisVertical;
  stack.spacing = 18;
  stack.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:stack];

  UILayoutGuide *safeArea = view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [scrollView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
    [scrollView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
    [scrollView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
    [scrollView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
    [contentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
    [contentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
    [contentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
    [contentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
    [contentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor],
    [stack.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:26],
    [stack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
    [stack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
    [stack.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-36]
  ]];

  UILabel *titleLabel = [self labelWithText:@"数学分层教学小助手" fontSize:26 weight:UIFontWeightBold color:0x1F2A44];
  UILabel *subtitleLabel = [self labelWithText:@"先从一名学生开始，录入情况后自动生成分层结果、学习方案和反馈话术。" fontSize:15 weight:UIFontWeightRegular color:0x60708F];
  subtitleLabel.numberOfLines = 0;

  UIStackView *headerStack = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, subtitleLabel]];
  headerStack.axis = UILayoutConstraintAxisVertical;
  headerStack.spacing = 8;
  [stack addArrangedSubview:headerStack];

  [stack addArrangedSubview:[self buildStudentCard]];
  [stack addArrangedSubview:[self buildResultCard]];
}

- (UIView *)buildStudentCard
{
  UIView *card = [self cardView];
  UIStackView *stack = [self stackInCard:card];

  [stack addArrangedSubview:[self labelWithText:@"学生信息" fontSize:20 weight:UIFontWeightBold color:0x1F2A44]];

  [stack addArrangedSubview:[self fieldLabel:@"学生姓名"]];
  self.nameField = [self textFieldWithText:@"小明" placeholder:@"例如：小明"];
  [self.nameField addTarget:self action:@selector(updateLearningPlan) forControlEvents:UIControlEventEditingChanged];
  [stack addArrangedSubview:self.nameField];

  [stack addArrangedSubview:[self fieldLabel:@"最近一次数学测验分数"]];
  self.scoreField = [self textFieldWithText:@"75" placeholder:@"0-100"];
  self.scoreField.keyboardType = UIKeyboardTypeNumberPad;
  [self.scoreField addTarget:self action:@selector(updateLearningPlan) forControlEvents:UIControlEventEditingChanged];
  [stack addArrangedSubview:self.scoreField];
  self.scoreHintLabel = [self labelWithText:@"" fontSize:13 weight:UIFontWeightRegular color:0x7C8AA5];
  [stack addArrangedSubview:self.scoreHintLabel];

  [stack addArrangedSubview:[self fieldLabel:@"常见数学问题"]];
  self.problemView = [[UITextView alloc] init];
  self.problemView.text = @"计算粗心、应用题审题不仔细";
  self.problemView.delegate = self;
  self.problemView.font = [UIFont systemFontOfSize:16];
  self.problemView.textColor = [self colorWithHex:0x1F2A44];
  self.problemView.backgroundColor = [self colorWithHex:0xF8FAFD];
  self.problemView.layer.borderColor = [self colorWithHex:0xDCE4F2].CGColor;
  self.problemView.layer.borderWidth = 1;
  self.problemView.layer.cornerRadius = 12;
  self.problemView.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
  [self.problemView.heightAnchor constraintEqualToConstant:88].active = YES;
  [stack addArrangedSubview:self.problemView];

  [stack addArrangedSubview:[self fieldLabel:@"作业情况"]];
  self.homeworkControl = [self segmentedControlWithItems:@[@"认真完成", @"偶尔拖拉", @"经常拖拉"] selectedIndex:1];
  [stack addArrangedSubview:self.homeworkControl];

  [stack addArrangedSubview:[self fieldLabel:@"学习态度"]];
  self.attitudeControl = [self segmentedControlWithItems:@[@"积极", @"一般", @"需要提醒"] selectedIndex:1];
  [stack addArrangedSubview:self.attitudeControl];

  return card;
}

- (UIView *)buildResultCard
{
  UIView *card = [self cardView];
  UIStackView *stack = [self stackInCard:card];

  [stack addArrangedSubview:[self labelWithText:@"自动生成结果" fontSize:20 weight:UIFontWeightBold color:0x1F2A44]];

  UIView *groupBox = [[UIView alloc] init];
  groupBox.backgroundColor = [self colorWithHex:0xEAF1FF];
  groupBox.layer.cornerRadius = 14;
  groupBox.translatesAutoresizingMaskIntoConstraints = NO;

  self.groupLabel = [self labelWithText:@"" fontSize:18 weight:UIFontWeightBold color:0x2150B5];
  self.groupGoalLabel = [self labelWithText:@"" fontSize:14 weight:UIFontWeightRegular color:0x3D5E9A];
  self.groupGoalLabel.numberOfLines = 0;

  UIStackView *groupStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.groupLabel, self.groupGoalLabel]];
  groupStack.axis = UILayoutConstraintAxisVertical;
  groupStack.spacing = 6;
  groupStack.translatesAutoresizingMaskIntoConstraints = NO;
  [groupBox addSubview:groupStack];
  [NSLayoutConstraint activateConstraints:@[
    [groupStack.topAnchor constraintEqualToAnchor:groupBox.topAnchor constant:14],
    [groupStack.leadingAnchor constraintEqualToAnchor:groupBox.leadingAnchor constant:14],
    [groupStack.trailingAnchor constraintEqualToAnchor:groupBox.trailingAnchor constant:-14],
    [groupStack.bottomAnchor constraintEqualToAnchor:groupBox.bottomAnchor constant:-14]
  ]];
  [stack addArrangedSubview:groupBox];

  [stack addArrangedSubview:[self sectionTitle:@"本周小目标"]];
  self.weeklyGoalLabel = [self paragraphLabel];
  [stack addArrangedSubview:self.weeklyGoalLabel];

  [stack addArrangedSubview:[self sectionTitle:@"个性化数学练习"]];
  self.tasksStack = [[UIStackView alloc] init];
  self.tasksStack.axis = UILayoutConstraintAxisVertical;
  self.tasksStack.spacing = 10;
  [stack addArrangedSubview:self.tasksStack];

  [stack addArrangedSubview:[self sectionTitle:@"监督反馈机制"]];
  self.supervisionLabel = [self paragraphLabel];
  [stack addArrangedSubview:self.supervisionLabel];

  [stack addArrangedSubview:[self sectionTitle:@"教师反馈话术"]];
  self.feedbackLabel = [self paragraphLabel];
  self.feedbackLabel.backgroundColor = [self colorWithHex:0xFFF8E6];
  self.feedbackLabel.layer.borderColor = [self colorWithHex:0xF4D68A].CGColor;
  self.feedbackLabel.layer.borderWidth = 1;
  self.feedbackLabel.layer.cornerRadius = 12;
  self.feedbackLabel.layer.masksToBounds = YES;
  [stack addArrangedSubview:self.feedbackLabel];

  return card;
}

- (UIView *)cardView
{
  UIView *card = [[UIView alloc] init];
  card.backgroundColor = UIColor.whiteColor;
  card.layer.cornerRadius = 18;
  card.layer.shadowColor = [self colorWithHex:0x0D1B2A].CGColor;
  card.layer.shadowOpacity = 0.08;
  card.layer.shadowRadius = 12;
  card.layer.shadowOffset = CGSizeMake(0, 6);
  return card;
}

- (UIStackView *)stackInCard:(UIView *)card
{
  UIStackView *stack = [[UIStackView alloc] init];
  stack.axis = UILayoutConstraintAxisVertical;
  stack.spacing = 12;
  stack.translatesAutoresizingMaskIntoConstraints = NO;
  [card addSubview:stack];
  [NSLayoutConstraint activateConstraints:@[
    [stack.topAnchor constraintEqualToAnchor:card.topAnchor constant:18],
    [stack.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:18],
    [stack.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-18],
    [stack.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-18]
  ]];
  return stack;
}

- (UILabel *)fieldLabel:(NSString *)text
{
  return [self labelWithText:text fontSize:15 weight:UIFontWeightSemibold color:0x2F3A55];
}

- (UILabel *)sectionTitle:(NSString *)text
{
  return [self labelWithText:text fontSize:16 weight:UIFontWeightBold color:0x1F2A44];
}

- (UILabel *)paragraphLabel
{
  UILabel *label = [self labelWithText:@"" fontSize:15 weight:UIFontWeightRegular color:0x40506A];
  label.numberOfLines = 0;
  return label;
}

- (UILabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize weight:(UIFontWeight)weight color:(NSUInteger)hex
{
  UILabel *label = [[UILabel alloc] init];
  label.text = text;
  label.font = [UIFont systemFontOfSize:fontSize weight:weight];
  label.textColor = [self colorWithHex:hex];
  label.numberOfLines = 1;
  return label;
}

- (UITextField *)textFieldWithText:(NSString *)text placeholder:(NSString *)placeholder
{
  UITextField *field = [[UITextField alloc] init];
  field.text = text;
  field.placeholder = placeholder;
  field.font = [UIFont systemFontOfSize:16];
  field.textColor = [self colorWithHex:0x1F2A44];
  field.backgroundColor = [self colorWithHex:0xF8FAFD];
  field.layer.borderColor = [self colorWithHex:0xDCE4F2].CGColor;
  field.layer.borderWidth = 1;
  field.layer.cornerRadius = 12;
  field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 1)];
  field.leftViewMode = UITextFieldViewModeAlways;
  [field.heightAnchor constraintEqualToConstant:46].active = YES;
  return field;
}

- (UISegmentedControl *)segmentedControlWithItems:(NSArray<NSString *> *)items selectedIndex:(NSInteger)selectedIndex
{
  UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:items];
  control.selectedSegmentIndex = selectedIndex;
  [control addTarget:self action:@selector(updateLearningPlan) forControlEvents:UIControlEventValueChanged];
  [control.heightAnchor constraintEqualToConstant:36].active = YES;
  return control;
}

- (void)textViewDidChange:(UITextView *)textView
{
  [self updateLearningPlan];
}

- (void)updateLearningPlan
{
  NSInteger score = [self normalizedScoreFromText:self.scoreField.text];
  NSDictionary *group = [self groupForScore:score];
  NSString *groupKey = group[@"key"];
  NSString *name = self.nameField.text.length > 0 ? self.nameField.text : @"同学";
  NSString *problem = [self trimmedString:self.problemView.text];
  NSString *focus = problem.length > 0 ? [NSString stringWithFormat:@"近期重点关注：%@。", problem] : @"先观察近期作业和测验，找出最常出现的数学问题。";
  NSString *homework = [self.homeworkControl titleForSegmentAtIndex:self.homeworkControl.selectedSegmentIndex];
  NSString *attitude = [self.attitudeControl titleForSegmentAtIndex:self.attitudeControl.selectedSegmentIndex];

  self.scoreHintLabel.text = [NSString stringWithFormat:@"当前按 %ld 分进行判断。", (long)score];
  self.groupLabel.text = group[@"label"];
  self.groupGoalLabel.text = group[@"goal"];
  self.weeklyGoalLabel.text = [self weeklyGoalForGroup:groupKey name:name];
  self.supervisionLabel.text = [self supervisionForGroup:groupKey];
  self.feedbackLabel.text = [NSString stringWithFormat:@"%@目前属于%@。%@从作业情况看，%@；从学习态度看，%@。下周建议继续完成小目标，做完题后主动检查，老师会根据完成情况给予及时反馈。", name, group[@"label"], focus, homework, attitude];

  for (UIView *view in self.tasksStack.arrangedSubviews) {
    [self.tasksStack removeArrangedSubview:view];
    [view removeFromSuperview];
  }

  NSArray<NSString *> *tasks = [self tasksForGroup:groupKey];
  for (NSUInteger index = 0; index < tasks.count; index++) {
    [self.tasksStack addArrangedSubview:[self taskRowWithNumber:index + 1 text:tasks[index]]];
  }
}

- (UIView *)taskRowWithNumber:(NSUInteger)number text:(NSString *)text
{
  UILabel *indexLabel = [self labelWithText:[NSString stringWithFormat:@"%lu", (unsigned long)number] fontSize:12 weight:UIFontWeightBold color:0xFFFFFF];
  indexLabel.backgroundColor = [self colorWithHex:0x2F6FED];
  indexLabel.layer.cornerRadius = 10;
  indexLabel.layer.masksToBounds = YES;
  indexLabel.textAlignment = NSTextAlignmentCenter;
  [indexLabel.widthAnchor constraintEqualToConstant:20].active = YES;
  [indexLabel.heightAnchor constraintEqualToConstant:20].active = YES;

  UILabel *taskLabel = [self paragraphLabel];
  taskLabel.text = text;

  UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[indexLabel, taskLabel]];
  row.axis = UILayoutConstraintAxisHorizontal;
  row.alignment = UIStackViewAlignmentTop;
  row.spacing = 10;
  return row;
}

- (NSInteger)normalizedScoreFromText:(NSString *)text
{
  NSInteger score = [text integerValue];
  if (score < 0) {
    return 0;
  }
  if (score > 100) {
    return 100;
  }
  return score;
}

- (NSDictionary *)groupForScore:(NSInteger)score
{
  if (score >= 85) {
    return @{@"key": @"extension", @"label": @"C组：能力拓展型", @"goal": @"加强思维表达、挑战综合题和拓展题"};
  }
  if (score >= 60) {
    return @{@"key": @"steady", @"label": @"B组：稳定提升型", @"goal": @"减少常见错误、提高熟练度和解题稳定性"};
  }
  return @{@"key": @"foundation", @"label": @"A组：基础巩固型", @"goal": @"先补基础、建立信心、保证正确率"};
}

- (NSString *)weeklyGoalForGroup:(NSString *)groupKey name:(NSString *)name
{
  if ([groupKey isEqualToString:@"foundation"]) {
    return [NSString stringWithFormat:@"%@本周目标：每天坚持完成基础练习，先把正确率稳定在80%以上。", name];
  }
  if ([groupKey isEqualToString:@"steady"]) {
    return [NSString stringWithFormat:@"%@本周目标：完成练习后主动检查，争取把粗心错误减少到2处以内。", name];
  }
  return [NSString stringWithFormat:@"%@本周目标：完成挑战题后能清楚讲出解题思路，并尝试总结方法。", name];
}

- (NSArray<NSString *> *)tasksForGroup:(NSString *)groupKey
{
  if ([groupKey isEqualToString:@"foundation"]) {
    return @[
      @"每天完成8-10分钟基础计算练习，题量少一点，但要求每题写清步骤。",
      @"每次练习后圈出1道最容易错的题，说出错因，比如“看错符号”或“忘记进位”。",
      @"优先练习课本例题和同类型变式题，暂时不增加太多难题。"
    ];
  }
  if ([groupKey isEqualToString:@"steady"]) {
    return @[
      @"每天完成10分钟巩固练习，包含基础计算题和1道应用题。",
      @"每周整理3道典型错题，写清“错在哪里”和“下次怎么检查”。",
      @"做应用题时先用横线标出关键信息，再列式计算。"
    ];
  }
  return @[
    @"每周完成2-3道挑战题，并尝试写出两种解法或解释思路。",
    @"安排“小老师讲题”任务，用自己的话讲清题目条件、方法和答案。",
    @"鼓励记录有价值的数学发现，比如规律、简便算法或容易混淆的条件。"
  ];
}

- (NSString *)supervisionForGroup:(NSString *)groupKey
{
  if ([groupKey isEqualToString:@"foundation"]) {
    return @"建议老师每周至少关注2次：一次检查基础任务，一次给出具体鼓励。";
  }
  if ([groupKey isEqualToString:@"steady"]) {
    return @"建议老师每周五进行一次简短反馈，重点看错题整理和检查习惯。";
  }
  return @"建议老师每周安排一次挑战展示，重点关注思路表达和方法总结。";
}

- (NSString *)trimmedString:(NSString *)text
{
  return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (UIColor *)colorWithHex:(NSUInteger)hex
{
  CGFloat red = ((hex >> 16) & 0xFF) / 255.0;
  CGFloat green = ((hex >> 8) & 0xFF) / 255.0;
  CGFloat blue = (hex & 0xFF) / 255.0;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
