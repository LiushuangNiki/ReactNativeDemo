/**
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';

const {generateLearningPlan, normalizeScore} = require('./learningPlan');

const HOMEWORK_OPTIONS = ['认真完成', '偶尔拖拉', '经常拖拉'];
const ATTITUDE_OPTIONS = ['积极', '一般', '需要提醒'];

type Props = {};
type State = {
  name: string,
  score: string,
  problem: string,
  homework: string,
  attitude: string,
};

export default class App extends Component<Props, State> {
  state = {
    name: '小明',
    score: '75',
    problem: '计算粗心、应用题审题不仔细',
    homework: HOMEWORK_OPTIONS[1],
    attitude: ATTITUDE_OPTIONS[1],
  };

  updateField = (field: string, value: string) => {
    this.setState({[field]: value});
  };

  renderOptionGroup(label: string, field: string, options: Array<string>) {
    return (
      <View style={styles.fieldBlock}>
        <Text style={styles.label}>{label}</Text>
        <View style={styles.optionRow}>
          {options.map(option => {
            const selected = this.state[field] === option;

            return (
              <TouchableOpacity
                key={option}
                style={[styles.optionButton, selected && styles.optionSelected]}
                onPress={() => this.updateField(field, option)}>
                <Text
                  style={[
                    styles.optionText,
                    selected && styles.optionSelectedText,
                  ]}>
                  {option}
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </View>
    );
  }

  renderTaskList(tasks: Array<string>) {
    return tasks.map((task, index) => (
      <View key={task} style={styles.taskItem}>
        <Text style={styles.taskIndex}>{index + 1}</Text>
        <Text style={styles.taskText}>{task}</Text>
      </View>
    ));
  }

  render() {
    const score = normalizeScore(this.state.score);
    const plan = generateLearningPlan({
      name: this.state.name,
      score,
      problem: this.state.problem,
      homework: this.state.homework,
      attitude: this.state.attitude,
    });

    return (
      <KeyboardAvoidingView
        style={styles.container}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
        <ScrollView
          contentContainerStyle={styles.content}
          keyboardShouldPersistTaps="handled">
          <View style={styles.header}>
            <Text style={styles.title}>数学分层教学小助手</Text>
            <Text style={styles.subtitle}>
              先从一名学生开始，录入情况后自动生成分层结果、学习方案和反馈话术。
            </Text>
          </View>

          <View style={styles.card}>
            <Text style={styles.cardTitle}>学生信息</Text>

            <View style={styles.fieldBlock}>
              <Text style={styles.label}>学生姓名</Text>
              <TextInput
                style={styles.input}
                value={this.state.name}
                onChangeText={value => this.updateField('name', value)}
                placeholder="例如：小明"
              />
            </View>

            <View style={styles.fieldBlock}>
              <Text style={styles.label}>最近一次数学测验分数</Text>
              <TextInput
                style={styles.input}
                value={this.state.score}
                onChangeText={value => this.updateField('score', value)}
                keyboardType="numeric"
                maxLength={3}
                placeholder="0-100"
              />
              <Text style={styles.hint}>当前按 {score} 分进行判断。</Text>
            </View>

            <View style={styles.fieldBlock}>
              <Text style={styles.label}>常见数学问题</Text>
              <TextInput
                style={[styles.input, styles.textArea]}
                value={this.state.problem}
                onChangeText={value => this.updateField('problem', value)}
                multiline
                placeholder="例如：计算粗心、审题不仔细、乘法口诀不熟"
              />
            </View>

            {this.renderOptionGroup('作业情况', 'homework', HOMEWORK_OPTIONS)}
            {this.renderOptionGroup('学习态度', 'attitude', ATTITUDE_OPTIONS)}
          </View>

          <View style={[styles.card, styles.resultCard]}>
            <Text style={styles.cardTitle}>自动生成结果</Text>

            <View style={styles.groupBox}>
              <Text style={styles.groupLabel}>{plan.group.label}</Text>
              <Text style={styles.groupGoal}>{plan.group.goal}</Text>
            </View>

            <Text style={styles.sectionTitle}>本周小目标</Text>
            <Text style={styles.paragraph}>{plan.weeklyGoal}</Text>

            <Text style={styles.sectionTitle}>个性化数学练习</Text>
            {this.renderTaskList(plan.tasks)}

            <Text style={styles.sectionTitle}>监督反馈机制</Text>
            <Text style={styles.paragraph}>{plan.supervision}</Text>

            <Text style={styles.sectionTitle}>教师反馈话术</Text>
            <Text style={styles.feedback}>{plan.feedback}</Text>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F3F6FB',
  },
  content: {
    padding: 20,
    paddingTop: 48,
  },
  header: {
    marginBottom: 18,
  },
  title: {
    color: '#1F2A44',
    fontSize: 26,
    fontWeight: '700',
    marginBottom: 8,
  },
  subtitle: {
    color: '#60708F',
    fontSize: 15,
    lineHeight: 22,
  },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 18,
    marginBottom: 18,
    padding: 18,
    shadowColor: '#0D1B2A',
    shadowOffset: {width: 0, height: 6},
    shadowOpacity: 0.08,
    shadowRadius: 12,
    elevation: 3,
  },
  resultCard: {
    marginBottom: 36,
  },
  cardTitle: {
    color: '#1F2A44',
    fontSize: 20,
    fontWeight: '700',
    marginBottom: 14,
  },
  fieldBlock: {
    marginBottom: 16,
  },
  label: {
    color: '#2F3A55',
    fontSize: 15,
    fontWeight: '600',
    marginBottom: 8,
  },
  input: {
    backgroundColor: '#F8FAFD',
    borderColor: '#DCE4F2',
    borderRadius: 12,
    borderWidth: 1,
    color: '#1F2A44',
    fontSize: 16,
    minHeight: 46,
    paddingHorizontal: 12,
    paddingVertical: 10,
  },
  textArea: {
    minHeight: 86,
    textAlignVertical: 'top',
  },
  hint: {
    color: '#7C8AA5',
    fontSize: 13,
    marginTop: 6,
  },
  optionRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginHorizontal: -4,
  },
  optionButton: {
    backgroundColor: '#F3F6FB',
    borderColor: '#DCE4F2',
    borderRadius: 999,
    borderWidth: 1,
    margin: 4,
    paddingHorizontal: 12,
    paddingVertical: 8,
  },
  optionSelected: {
    backgroundColor: '#2F6FED',
    borderColor: '#2F6FED',
  },
  optionText: {
    color: '#52627A',
    fontSize: 14,
  },
  optionSelectedText: {
    color: '#FFFFFF',
    fontWeight: '600',
  },
  groupBox: {
    backgroundColor: '#EAF1FF',
    borderRadius: 14,
    marginBottom: 18,
    padding: 14,
  },
  groupLabel: {
    color: '#2150B5',
    fontSize: 18,
    fontWeight: '700',
    marginBottom: 6,
  },
  groupGoal: {
    color: '#3D5E9A',
    fontSize: 14,
    lineHeight: 20,
  },
  sectionTitle: {
    color: '#1F2A44',
    fontSize: 16,
    fontWeight: '700',
    marginBottom: 8,
    marginTop: 8,
  },
  paragraph: {
    color: '#40506A',
    fontSize: 15,
    lineHeight: 22,
    marginBottom: 12,
  },
  taskItem: {
    flexDirection: 'row',
    marginBottom: 10,
  },
  taskIndex: {
    backgroundColor: '#2F6FED',
    borderRadius: 10,
    color: '#FFFFFF',
    fontSize: 12,
    fontWeight: '700',
    height: 20,
    lineHeight: 20,
    marginRight: 10,
    textAlign: 'center',
    width: 20,
  },
  taskText: {
    color: '#40506A',
    flex: 1,
    fontSize: 15,
    lineHeight: 22,
  },
  feedback: {
    backgroundColor: '#FFF8E6',
    borderColor: '#F4D68A',
    borderRadius: 12,
    borderWidth: 1,
    color: '#5A4312',
    fontSize: 15,
    lineHeight: 23,
    padding: 12,
  },
});
