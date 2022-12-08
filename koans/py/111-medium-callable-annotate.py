"""
Koan to learn annotating the callables or functions.
"""

# Annotate the function arguments
# Documentation: https://docs.python.org/3/library/typing.html?highlight=typing#callable
# Documentation: https://docs.python.org/3/library/typing.html?highlight=typing#typing.Iterable
from _typeshed import SupportsRichComparison
from typing import Callable, Iterable, List, TypeVar, TypedDict, Type

class UserData(TypedDict):
    user_id: int
    is_active: bool

T = TypeVar("T")
def user_sort(data: Iterable[T], func: Callable[[T],SupportsRichComparison]) -> List[T]:
    return sorted(data, key=func)


def key_func(item: UserData) -> SupportsRichComparison:
    return item["user_id"]



def main() -> None:
    # Annotate the data
    data: List[UserData] = [
        {"user_id": 1, "is_active": True},
        {"user_id": 34, "is_active": True},
        {"user_id": 3, "is_active": False},
    ]

    assert user_sort(data, key_func)


if __name__ == "__main__":
    main()
