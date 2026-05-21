const GROUPS = {
  foundation: {
    key: 'foundation',
    label: 'A组：基础巩固型',
    shortLabel: 'A组',
    goal: '先补基础、建立信心、保证正确率',
  },
  steady: {
    key: 'steady',
    label: 'B组：稳定提升型',
    shortLabel: 'B组',
    goal: '减少常见错误、提高熟练度和解题稳定性',
  },
  extension: {
    key: 'extension',
    label: 'C组：能力拓展型',
    shortLabel: 'C组',
    goal: '加强思维表达、挑战综合题和拓展题',
  },
};

const DAILY_TASKS = {
  foundation: [
    '每天完成8-10分钟基础计算练习，题量少一点，但要求每题写清步骤。',
    '每次练习后圈出1道最容易错的题，说出错因，比如“看错符号”或“忘记进位”。',
    '优先练习课本例题和同类型变式题，暂时不增加太多难题。',
  ],
  steady: [
    '每天完成10分钟巩固练习，包含基础计算题和1道应用题。',
    '每周整理3道典型错题，写清“错在哪里”和“下次怎么检查”。',
    '做应用题时先用横线标出关键信息，再列式计算。',
  ],
  extension: [
    '每周完成2-3道挑战题，并尝试写出两种解法或解释思路。',
    '安排“小老师讲题”任务，用自己的话讲清题目条件、方法和答案。',
    '鼓励记录有价值的数学发现，比如规律、简便算法或容易混淆的条件。',
  ],
};

const SUPERVISION = {
  foundation: '建议老师每周至少关注2次：一次检查基础任务，一次给出具体鼓励。',
  steady: '建议老师每周五进行一次简短反馈，重点看错题整理和检查习惯。',
  extension: '建议老师每周安排一次挑战展示，重点关注思路表达和方法总结。',
};

function normalizeScore(value) {
  const score = Number(value);

  if (Number.isNaN(score)) {
    return 0;
  }

  if (score < 0) {
    return 0;
  }

  if (score > 100) {
    return 100;
  }

  return Math.round(score);
}

function classifyStudent(score) {
  const normalizedScore = normalizeScore(score);

  if (normalizedScore >= 85) {
    return GROUPS.extension;
  }

  if (normalizedScore >= 60) {
    return GROUPS.steady;
  }

  return GROUPS.foundation;
}

function getMathFocus(problemText) {
  const problem = (problemText || '').trim();

  if (!problem) {
    return '先观察近期作业和测验，找出最常出现的数学问题。';
  }

  return '近期重点关注：' + problem + '。';
}

function generateLearningPlan(student) {
  const group = classifyStudent(student.score);
  const tasks = DAILY_TASKS[group.key];
  const focus = getMathFocus(student.problem);

  return {
    group,
    focus,
    tasks,
    supervision: SUPERVISION[group.key],
    weeklyGoal: buildWeeklyGoal(group, student),
    feedback: buildFeedback(group, student, focus),
  };
}

function buildWeeklyGoal(group, student) {
  const name = student.name || '这名学生';

  if (group.key === 'foundation') {
    return name + '本周目标：每天坚持完成基础练习，先把正确率稳定在80%以上。';
  }

  if (group.key === 'steady') {
    return name + '本周目标：完成练习后主动检查，争取把粗心错误减少到2处以内。';
  }

  return name + '本周目标：完成挑战题后能清楚讲出解题思路，并尝试总结方法。';
}

function buildFeedback(group, student, focus) {
  const name = student.name || '同学';
  const homework = student.homework || '作业情况待观察';
  const attitude = student.attitude || '学习态度待观察';

  return (
    name +
    '目前属于' +
    group.label +
    '。' +
    focus +
    '从作业情况看，' +
    homework +
    '；从学习态度看，' +
    attitude +
    '。下周建议继续完成小目标，做完题后主动检查，老师会根据完成情况给予及时反馈。'
  );
}

module.exports = {
  GROUPS,
  normalizeScore,
  classifyStudent,
  generateLearningPlan,
};
