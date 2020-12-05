package firmware.hardware.memory;

class EEPROMemory extends AbstractMemory 
{
    public override function get_Type(): MemoryType
        return MemoryType.EEPROM;

    public function new(size: Int, pageSize: Int = 0) 
        super(size, pageSize);
}