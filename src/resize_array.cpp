struct ResizeArrayHeader {
    size_t sizeOfElement;
    int elementsCount;
    int maxCount;
    int incrementCount;
};

#define DEFAULT_RESIZE_ARRAY_SIZE 1

#define initResizeArray(type) (type *)initResizeArray_(sizeof(type))

u8 *initResizeArray_(size_t sizeOfElement, int incrementCount = DEFAULT_RESIZE_ARRAY_SIZE) {
    ResizeArrayHeader *header =(ResizeArrayHeader *)easyPlatform_allocateMemory(incrementCount*sizeOfElement + sizeof(ResizeArrayHeader), EASY_PLATFORM_MEMORY_ZERO);
    u8 *array = ((u8 *)header) + sizeof(ResizeArrayHeader);

    header->sizeOfElement = sizeOfElement;
    header->elementsCount = 0;
    header->maxCount = incrementCount;
    header->incrementCount = incrementCount;

    return array;
}

ResizeArrayHeader *getResizeArrayHeader(u8 *array) {
    ResizeArrayHeader *header = (ResizeArrayHeader *)(((u8 *)array) - sizeof(ResizeArrayHeader));
    return header;
}

u8 *getResizeArrayContents(ResizeArrayHeader *header) {
    u8 *array = ((u8 *)header) + sizeof(ResizeArrayHeader);
    return array;
}

int getArrayLength(void *array) {
    ResizeArrayHeader *header = getResizeArrayHeader((u8 *)array);
    assert(header->elementsCount <= header->maxCount);
    int result = header->elementsCount;
    return result;
}

#define pushArrayItem(array_, data, type)  (type *)pushArrayItem_(array_, &data)
u8 *pushArrayItem_(void *array_, void *data) {
    u8 *array = (u8 *)array_;
    u8 *newPos = 0;
    if(array) {
        ResizeArrayHeader *header = getResizeArrayHeader(array);

        if(header->elementsCount == header->maxCount) {
            //NOTE: Resize array
            size_t oldSize = header->maxCount*header->sizeOfElement + sizeof(ResizeArrayHeader);
            size_t newSize = oldSize + header->incrementCount*header->sizeOfElement;
            header = (ResizeArrayHeader *)easyPlatform_reallocMemory(header, oldSize, newSize);

            array = getResizeArrayContents(header);

            header->maxCount += header->incrementCount;

        } 

        newPos = array + (header->elementsCount * header->sizeOfElement);
        header->elementsCount++;

        easyPlatform_copyMemory(newPos, data, header->sizeOfElement);
    }

    return array;
}