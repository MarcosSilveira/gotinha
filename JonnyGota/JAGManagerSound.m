//
//  JAGManagerSound.m
//  JonnyGota
//
//  Created by Henrique Manfroi da Silveira on 06/12/14.
//  Copyright (c) 2014 Henrique Manfroi da Silveira. All rights reserved.
//

#import "JAGManagerSound.h"

@implementation JAGManagerSound

static JAGManagerSound *sharedMyManager;

static ALCdevice *openALDevice;
static ALCcontext *openALContext;

-(id)init{
    if (self = [super init]) {
        openALDevice = alcOpenDevice(NULL);
        
        openALContext = alcCreateContext(openALDevice, NULL);
        alcMakeContextCurrent(openALContext);
        self.sound=[[NSMutableDictionary alloc] init];
        self.playing=[[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reative) name:@"reativarSom" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inative) name:@"desativarSom" object:nil];
    }
    return self;}

+ (id)sharedManager {
    if (sharedMyManager==nil) {
        sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}

-(void)addSound:(NSString *)url withEffects:(BOOL)efeito withKey:(NSString *) key{
    
    
    if ([[self.sound objectForKey:key] intValue]==nil) {
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:url ofType:@"caf"];
        if (filePath!=nil) {
            
            
            NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
            
            
            alGenSources(1, &_outputSource);
            
            alSourcef(_outputSource, AL_PITCH, 1.0f);
            
            alSourcef(_outputSource, AL_GAIN, 1.0f);
            
            
            alGenBuffers(1, &_outputBuffer);
            
            alListener3f(AL_POSITION, 0.0f, 0.0f, 0.0f);
            alListener3f(AL_VELOCITY,
                         0.0f,
                         0.0f,
                         0.0f);
            
            alListener3f(AL_ORIENTATION,0.0f, 0.0f, 0.0f);
            
            
            AudioFileID afid;
            OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)fileUrl, kAudioFileReadPermission, 0, &afid);
            
            if (0 != openResult) {
                // NSLog(@"An error occurred when attempting to open the audio file %@: %ld", filePath, openResult);
                return;
            }
            
            UInt64 fileSizeInBytes = 0;
            UInt32 propSize = sizeof(fileSizeInBytes);
            
            OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes);
            
            UInt32 bytesRead = (UInt32)fileSizeInBytes;
            
            void* audioData = malloc(bytesRead);
            
            
            
            OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
            
            
            AudioFileClose(afid);
            
            
            
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
            
            alSourcei(_outputSource, AL_SOURCE_RELATIVE, AL_TRUE);
            alSource3f (_outputSource, AL_POSITION, -1.0f, -1.0f, 1.0f);
            alSource3f (_outputSource, AL_VELOCITY,1.0f, 1.0f, 1.0f);
            
            [self.sound setValue:[NSNumber numberWithInt:_outputSource] forKey:key];
            [self.playing setValue:[NSNumber numberWithInt:0] forKey:key];
        }else{
            NSLog(@"Arrumar referencia do som %@",url);
        }
    }
}

-(void)stopSound:(NSString *)key{
    ALuint outputSource = (ALuint)[[self.sound objectForKey:key] intValue];
    
    alSourceStop(outputSource);
    [self.playing setValue:[NSNumber numberWithInt:0] forKey:key];
}

-(void)playSound:(NSString *)key{
    if ([[self.playing objectForKey:key] intValue]!=1) {
    ALuint outputSource = (ALuint)[[self.sound objectForKey:key] intValue];
    
    alSourcePlay(outputSource);
//    [self.playing setValue:[NSNumber numberWithInt:1] forKey:key];
        
        //Liberar esse som
        
    }
}

-(void)changeVolume:(NSString *)key withSound:(float)vol{
    ALuint outputSource = (ALuint)[[self.sound objectForKey:key] intValue];
    alSourcef(_outputSource, AL_GAIN, vol);
}

-(void)configureListener:(NSString *)key withX:(float)x withY:(float)y withZ:(float)z{
    ALuint outputSource = (ALuint)[[self.sound objectForKey:key] intValue];
    
    alSourcei(outputSource, AL_SOURCE_RELATIVE, AL_TRUE);
    alSource3f (outputSource, AL_POSITION, x, y, z);

}

-(void)liberar{
    for (NSString* key in self.sound) {
         ALuint outputSource = (ALuint)[[self.sound objectForKey:key] intValue];
        alDeleteSources(1, &outputSource);
//        id value = [self.sound objectForKey:key];
        
        // do stuff
    }
    
    
    //
    alDeleteBuffers(1, &_outputBuffer);
    alcDestroyContext(openALContext);
    alcCloseDevice(openALDevice);
}

-(void)playInLoop:(NSString *)key{
    if ([[self.playing objectForKey:key] intValue]!=1) {
        ALuint outputSource = (ALuint)[[self.sound objectForKey:key] intValue];
        
        alSourcei(outputSource, AL_LOOPING, AL_TRUE);
        
        alSourcePlay(outputSource);
        
        [self.playing setValue:[NSNumber numberWithInt:1] forKey:key];
    }
}

-(NSTimeInterval)duration:(NSString *)key{
    ALuint outputSource = (ALuint)[[self.sound objectForKey:key] intValue];
    
    ALint bufferID, bufferSize, frequency, bitsPerSample, channels;
    alGetSourcei(outputSource, AL_BUFFER, &bufferID);
    alGetBufferi(bufferID, AL_SIZE, &bufferSize);
    alGetBufferi(bufferID, AL_FREQUENCY, &frequency);
    alGetBufferi(bufferID, AL_CHANNELS, &channels);
    alGetBufferi(bufferID, AL_BITS, &bitsPerSample);
    
    NSTimeInterval result = ((double)bufferSize)/(frequency*channels*(bitsPerSample/8));
    
    //    NSLog(@"duration in seconds %lf", result);
    
    return result;
}

-(void)stopAll{
    
}

-(void)inative{
    alcMakeContextCurrent(NULL);
}

-(void)reative{
    alcMakeContextCurrent(openALContext);
}



-(SKAction*)playButton{
    [self addSound:@"botaoUI1" withEffects:NO withKey:@"botao1"];
    
    
    
    SKAction *seq=[SKAction sequence:@[[SKAction runBlock:^{
        [self playSound:@"botao1"];
    }],[SKAction waitForDuration:[self duration:@"botao1"]]]];
    
    return seq;
}

-(void)liberarPlay{
    
}

@end
