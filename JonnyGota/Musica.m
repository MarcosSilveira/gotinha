//
//  Musica.m
//  AudiosTestes
//
//  Created by Henrique Manfroi da Silveira on 10/07/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "Musica.h"



@implementation Musica

static ALCdevice* openDevice;

static ALCcontext* openContext;

//init
- (instancetype)init{
    if (self = [super init]) {
        /* Setup your scene here */
        if(openDevice == nil){
            openDevice = alcOpenDevice(NULL);
            
        }
    }
    return self;
}


-(instancetype)initWithContext:(ALCcontext *)cont{
    
    if (self = [super init]) {
        /* Setup your scene here */
        if(openDevice == nil){
//            openDevice = alcOpenDevice(NULL);
            
            openContext = cont;
        }
    }
    return self;
}


-(void)inici{
    if(openDevice !=nil && openContext==nil){
        openContext = alcCreateContext(openDevice, NULL);
    
        alcMakeContextCurrent(openContext);
    }
}

-(void)configure:(ALCcontext *)context {
    openContext = context;
}

-(void)carregar:(NSString *)url withEffects:(BOOL)efeito{
    
    alGenSources(1, &_outputSource);
    
   // alSourcei(_outputSource, AL_BUFFER, pWAV->m_Buffer);
    //alSourcei(_outputSource, AL_REFERENCE_DISTANCE, m_maxGain); // 1.0f
  //  alSourcei(_outputSource, AL_MAX_DISTANCE, m_maxDistance);
    
    alSourcef(_outputSource, AL_PITCH, 1.0f);
    
    alSourcef(_outputSource, AL_GAIN, 1.0f);
    
    
    alGenBuffers(1, &_outputBuffer);
    
    alListener3f(AL_POSITION, 0.0f, 0.0f, 0.0f);
    alListener3f(AL_VELOCITY,
                 0.0f,
                 0.0f,
                 0.0f);
    
    alListener3f(AL_ORIENTATION,0.0f, 0.0f, 0.0f);
    
    
    //NSString* filePath = [[NSBundle mainBundle] pathForResource:@"DreamOfLife" ofType:@"caf"];
   // NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    
    
    AudioFileID afid;
    OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)url, kAudioFileReadPermission, 0, &afid);
    
    if (0 != openResult) {
       // NSLog(@"An error occurred when attempting to open the audio file %@: %ld", filePath, openResult);
        return;
    }
    
    UInt64 fileSizeInBytes = 0;
    UInt32 propSize = sizeof(fileSizeInBytes);
    
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes);
    
    if (0 != getSizeResult) {
      //  NSLog(@"An error occurred when attempting to determine the size of audio file %@: %ld", filePath, getSizeResult);
    }
    
    UInt32 bytesRead = (UInt32)fileSizeInBytes;
    
    void* audioData = malloc(bytesRead);
    
    
    
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    
    if (0 != readBytesResult) {
       // NSLog(@"An error occurred when attempting to read data from audio file %@: %ld", filePath, readBytesResult);
    }
    
    
    AudioFileClose(afid);
    
    
   // alBufferData(_outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 24100);
    if (efeito) {
        alBufferData(_outputBuffer, AL_FORMAT_MONO16, audioData, bytesRead, 24100);
      
        alSourcei(_outputSource, AL_MAX_DISTANCE, 2000.0f);
    }else{
        alBufferData(_outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 24100);
    }
    

    
    
    if (audioData) {
        free(audioData);
        audioData = NULL;
    }
    
    
    
    alDistanceModel(AL_LINEAR_DISTANCE);
    
    alSourcei(_outputSource, AL_BUFFER, _outputBuffer);
    
    //alSourcei(id, AL_SOURCE_RELATIVE, AL_TRUE);
    //alSourcef(id, AL_ROLLOFF_FACTOR, 0.0f);
    //alSource3f(id, AL_POSITION, 0.0, 0.0, 0.0)
    

    //alSourcePlay(_outputSource);
    /*
    float dist = camera1->o.dist(vec(e->x, e->y, e->z));
    float gain = 0.0f;
    // clamp to full gain (attr3 is a object "size" property)
     if(dist >= e->attr3) gain = 0.0f;
     else if(dist attr2) gain = 1.0f – dist/(float)e->attr2;
     alSourcef(id, AL_GAIN, gain);
     
     */
    
    alSourcei(_outputSource, AL_SOURCE_RELATIVE, AL_TRUE);
    alSource3f (_outputSource, AL_POSITION, -1.0f, -1.0f, 1.0f);
    alSource3f (_outputSource, AL_VELOCITY,1.0f, 1.0f, 1.0f);
}

-(void)soltar{
     alDeleteSources(1, &_outputSource);
     alDeleteBuffers(1, &_outputBuffer);
     alcDestroyContext(openContext);
     alcCloseDevice(openDevice);
    
    openContext=nil;
    openDevice=nil;
}


-(void)updateListener:(float)x withY:(float)y withZ:(float)z{
    alListener3f(AL_POSITION, x, y, z);
    alListener3f(AL_VELOCITY,
                 x,
                 y,
                 z);
    
    alListener3f(AL_ORIENTATION,x, y, z);

}

-(void)play{
    alSourcePlay(_outputSource);
}

-(void)playEffects{
    alSourcei(_outputSource, AL_SOURCE_RELATIVE, AL_TRUE);
    alSource3f (_outputSource, AL_POSITION, 500.0f, 500.0f, 100.0f);
    alSource3f (_outputSource, AL_VELOCITY, 10.0f, 10.0f, 10.0f);
    alSourcePlay(_outputSource);
}

-(void)configureEffects:(float)x withY:(float)y withZ:(float)z{
    //[self stop];

    /*
    alListener3f(AL_POSITION, LPos.X, LPos.Y, LPos.Z);
    alListener3f(AL_VELOCITY,
                 LPos.X - pListener->m_LastPos.X,
                 LPos.Y - pListener->m_LastPos.Y,
                 LPos.Z - pListener->m_LastPos.Z);
    */
    alSourcei(_outputSource, AL_SOURCE_RELATIVE, AL_TRUE);
    alSource3f (_outputSource, AL_POSITION, x, y, z);
//    alSource3f (_outputSource, AL_VELOCITY, x, y, z);
   // alSourcePlay(_outputSource);
}

-(void)stop{
    alSourceStop(_outputSource);
}

-(void)playInLoop{
    /*
    IntBuffer source =BufferUtils.createIntBuffer(128);
    int type;
   // alSO
    int repeats = 2;
    alSourcei(source.get(type), AL10.AL_LOOPING, AL10.AL_FALSE);
    for(int i = 0; i < repeats; i++)
        alSourceQueueBuffers(source.get(type), buffer.get(type));
    
    alSourcePlay(source.get(type));
     
     */
    
    alSourcei(_outputSource, AL_LOOPING, AL_TRUE);
    
    alSourcePlay(_outputSource);
}

-(void)changeVolume:(float)vol{
    alSourcef(_outputSource, AL_GAIN, vol);
}

@end
