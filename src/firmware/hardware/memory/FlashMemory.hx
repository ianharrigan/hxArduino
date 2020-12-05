package firmware.hardware.memory;

class FlashMemory extends AbstractMemory 
{
    public override function get_Type(): MemoryType 
        return MemoryType.Flash;

    public function new(size: Int, pageSize: Int = 0) 
        super(size, pageSize);
}