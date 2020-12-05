package firmware.hardware.memory;

interface IMemory {
    public var Type(get, never): MemoryType;
    public var Size: Int;
    public var PageSize: Int;
}