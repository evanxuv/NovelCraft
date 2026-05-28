import { describe, expect, it } from 'vitest';

import { createStreamBuffer } from '../sse';

describe('createStreamBuffer', () => {
  it('appends delta chunks and preserves metadata', () => {
    const buffer = createStreamBuffer();

    buffer.handleEvent({ type: 'metadata', payload: { taskId: 'demo' } });
    buffer.handleEvent({ type: 'delta', payload: { text: '第一段' } });
    buffer.handleEvent({ type: 'delta', payload: { text: '，第二段' } });
    buffer.handleEvent({ type: 'completed', payload: { taskId: 'demo' } });

    expect(buffer.snapshot()).toEqual({
      taskId: 'demo',
      text: '第一段，第二段',
      completed: true,
      error: null
    });
  });

  it('records model errors without discarding received text', () => {
    const buffer = createStreamBuffer();

    buffer.handleEvent({ type: 'delta', payload: { text: '已生成内容' } });
    buffer.handleEvent({ type: 'error', payload: { message: '模型调用失败' } });

    expect(buffer.snapshot()).toEqual({
      taskId: null,
      text: '已生成内容',
      completed: false,
      error: '模型调用失败'
    });
  });
});
