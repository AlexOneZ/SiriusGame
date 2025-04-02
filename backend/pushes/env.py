import os
import dotenv

dotenv.load_dotenv(verbose=True)


def getenv(variable: str) -> str:
    """
    Get the value of the specified environment variable.

    Args:
        variable (str): The name of the environment variable to retrieve.

    Returns:
        str: The value of the specified environment variable.

    Raises:
        NameError: If the specified environment variable is not defined.
    """
    value = os.getenv(variable)
    if value is not None:
        return value
    else:
        raise NameError(f"Error: {variable} Environment Variable not Defined")
