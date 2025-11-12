"""
File Upload Utilities

Handles file validation, upload, and storage.
"""

import os
import uuid
from typing import Optional
from fastapi import UploadFile, HTTPException, status
from PIL import Image
import aiofiles

from app.config.settings import settings


def validate_file(file: UploadFile) -> bool:
    """
    Validate uploaded file type and size.

    Args:
        file: Uploaded file

    Returns:
        bool: True if valid

    Raises:
        HTTPException: If file is invalid
    """
    # Check file extension
    if not file.filename:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No filename provided"
        )

    file_ext = file.filename.split(".")[-1].lower()
    if file_ext not in settings.ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"File type not allowed. Allowed types: {', '.join(settings.ALLOWED_EXTENSIONS)}"
        )

    return True


def generate_unique_filename(original_filename: str) -> str:
    """
    Generate a unique filename to prevent collisions.

    Args:
        original_filename: Original file name

    Returns:
        str: Unique filename
    """
    file_ext = original_filename.split(".")[-1].lower()
    unique_name = f"{uuid.uuid4()}.{file_ext}"
    return unique_name


async def save_file(file: UploadFile, directory: str = None) -> str:
    """
    Save uploaded file to disk.

    Args:
        file: Uploaded file
        directory: Optional subdirectory within UPLOAD_DIR

    Returns:
        str: Relative file path

    Raises:
        HTTPException: If save fails
    """
    try:
        # Validate file
        validate_file(file)

        # Generate unique filename
        unique_filename = generate_unique_filename(file.filename)

        # Determine save path
        if directory:
            save_dir = os.path.join(settings.UPLOAD_DIR, directory)
            os.makedirs(save_dir, exist_ok=True)
            file_path = os.path.join(save_dir, unique_filename)
            relative_path = os.path.join(directory, unique_filename)
        else:
            file_path = os.path.join(settings.UPLOAD_DIR, unique_filename)
            relative_path = unique_filename

        # Save file
        async with aiofiles.open(file_path, 'wb') as out_file:
            content = await file.read()

            # Check file size
            if len(content) > settings.MAX_FILE_SIZE:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"File size exceeds maximum allowed size of {settings.MAX_FILE_SIZE / 1024 / 1024}MB"
                )

            await out_file.write(content)

        # Verify it's a valid image
        try:
            img = Image.open(file_path)
            img.verify()
        except Exception:
            # Delete invalid file
            if os.path.exists(file_path):
                os.remove(file_path)
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid image file"
            )

        return relative_path

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to save file: {str(e)}"
        )


def delete_file(file_path: str) -> bool:
    """
    Delete a file from storage.

    Args:
        file_path: Relative file path

    Returns:
        bool: True if deleted successfully
    """
    try:
        full_path = os.path.join(settings.UPLOAD_DIR, file_path)
        if os.path.exists(full_path):
            os.remove(full_path)
            return True
        return False
    except Exception:
        return False


def get_file_url(filename: str) -> str:
    """
    Generate accessible URL for uploaded file.

    Args:
        filename: File name or relative path

    Returns:
        str: File URL
    """
    return f"/uploads/{filename}"
