from typing import Iterator, Callable

STOP = object()


class Task:
    def __init__(self):
        self.result = None

    def execute(self) -> Iterator:
        yield None

    def __call__(self, *args, **kwargs) -> Iterator:
        return self.execute()


class TaskDispatcher:
    def __init__(self):
        self.call_stack: list[Iterator] = []

    def run(self, task: Iterator):
        self.call_stack.append(task)

    def dispatch(self):
        call_stack = self.call_stack
        while True:
            if len(call_stack) == 0:
                break
            task = call_stack.pop()
            if isinstance(task, Iterator):
                # it's coroutine. execute it
                try:
                    # the return value may be
                    # a coroutine, a task or an indicator
                    new_task = next(task)
                except StopIteration:
                    # coroutine ends. go to next cmd
                    break
                if isinstance(new_task, Iterator):
                    # returns a new coroutine,
                    # push previous to call stack
                    call_stack.append(task)
                    # push new one to call stack
                    call_stack.append(new_task)
                elif isinstance(new_task, Callable):
                    # returns a Task, which means the calling is hanged on
                    # push previous to call stack
                    call_stack.append(task)
                    # execute the Task to get a coroutine and push it to call stack
                    co = new_task()
                    call_stack.append(co)
                elif new_task is STOP:
                    # instantly break the coroutine
                    break
                elif new_task is None:
                    # return None as default, which means task over.
                    pass
                else:
                    raise Exception(f"unsupported coroutine type {type(new_task).__name__} {new_task}")
