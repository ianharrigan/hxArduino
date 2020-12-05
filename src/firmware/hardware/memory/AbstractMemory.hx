package firmware.hardware.memory;

class AbstractMemory implements IMemory
{
    public var Type(get, never): MemoryType;
    public var Size: Int;
    public var PageSize: Int;

    public function get_Type(): MemoryType 
        return MemoryType.Unknown;

    private function new(size: Int, pageSize: Int = 0) {
        this.Size = size;
        this.PageSize = pageSize;
    }
}