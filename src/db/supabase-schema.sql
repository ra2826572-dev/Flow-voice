-- =====================================================
-- VOICEFLOW AI — SUPABASE DATABASE SCHEMA MIGRATION
-- =====================================================

-- 1. Users Table
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT DEFAULT 'user',
  avatar_url TEXT,
  character_limit INT DEFAULT 100000,
  characters_used INT DEFAULT 0,
  plan TEXT DEFAULT 'pro',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Projects Table
CREATE TABLE IF NOT EXISTS public.projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  type TEXT NOT NULL, -- 'audio' | 'video' | 'script' | 'dubbing' | 'clone'
  duration FLOAT DEFAULT 0,
  language TEXT,
  audio_url TEXT,
  status TEXT DEFAULT 'completed',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Audio / TTS History Table
CREATE TABLE IF NOT EXISTS public.audio_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  voice_id TEXT NOT NULL,
  voice_name TEXT NOT NULL,
  language TEXT NOT NULL,
  audio_url TEXT NOT NULL,
  duration FLOAT DEFAULT 0,
  character_count INT DEFAULT 0,
  settings JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Translation History Table
CREATE TABLE IF NOT EXISTS public.translation_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  original_text TEXT NOT NULL,
  source_language TEXT NOT NULL,
  translated_text TEXT NOT NULL,
  target_language TEXT NOT NULL,
  character_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Cloned Voices Table
CREATE TABLE IF NOT EXISTS public.cloned_voices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  gender TEXT NOT NULL,
  accent TEXT NOT NULL,
  sample_duration FLOAT DEFAULT 30,
  consent_confirmed BOOLEAN DEFAULT TRUE,
  sample_audio_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audio_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.translation_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cloned_voices ENABLE ROW LEVEL SECURITY;
