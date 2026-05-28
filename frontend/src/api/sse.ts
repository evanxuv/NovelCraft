export type StreamEventType = 'metadata' | 'delta' | 'heartbeat' | 'error' | 'completed';

export interface StreamEvent {
  type: StreamEventType;
  payload: Record<string, unknown>;
}

export interface StreamSnapshot {
  taskId: string | null;
  text: string;
  completed: boolean;
  error: string | null;
}

export function createStreamBuffer() {
  let taskId: string | null = null;
  let text = '';
  let completed = false;
  let error: string | null = null;

  return {
    handleEvent(event: StreamEvent) {
      if (event.type === 'metadata' || event.type === 'completed') {
        taskId = readString(event.payload.taskId) ?? taskId;
      }

      if (event.type === 'delta') {
        text += readString(event.payload.text) ?? '';
      }

      if (event.type === 'completed') {
        completed = true;
      }

      if (event.type === 'error') {
        error = readString(event.payload.message) ?? 'AI generation failed';
      }
    },
    snapshot(): StreamSnapshot {
      return { taskId, text, completed, error };
    }
  };
}

function readString(value: unknown): string | null {
  return typeof value === 'string' ? value : null;
}
