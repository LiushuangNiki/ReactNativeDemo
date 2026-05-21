const {
  classifyStudent,
  generateLearningPlan,
  normalizeScore,
} = require('../learningPlan');

describe('learning plan helpers', () => {
  it('normalizes score values into the 0-100 range', () => {
    expect(normalizeScore('-5')).toBe(0);
    expect(normalizeScore('72.4')).toBe(72);
    expect(normalizeScore('120')).toBe(100);
    expect(normalizeScore('not a score')).toBe(0);
  });

  it('classifies students by score boundaries', () => {
    expect(classifyStudent(59).label).toBe('A组：基础巩固型');
    expect(classifyStudent(60).label).toBe('B组：稳定提升型');
    expect(classifyStudent(84).label).toBe('B组：稳定提升型');
    expect(classifyStudent(85).label).toBe('C组：能力拓展型');
  });

  it('generates a math plan with the student context', () => {
    const plan = generateLearningPlan({
      name: '小明',
      score: 75,
      problem: '计算粗心',
      homework: '偶尔拖拉',
      attitude: '一般',
    });

    expect(plan.group.label).toBe('B组：稳定提升型');
    expect(plan.weeklyGoal).toContain('小明');
    expect(plan.focus).toContain('计算粗心');
    expect(plan.feedback).toContain('偶尔拖拉');
  });
});
