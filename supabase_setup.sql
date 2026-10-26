-- Divya Desams: private cloud-sync buckets for progress and user-uploaded photos.
-- Run this entire script in Supabase Dashboard > SQL Editor.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('divya-yatra-backups', 'divya-yatra-backups', false, 10485760, array['application/json'])
on conflict (id) do update set public = false, file_size_limit = 10485760, allowed_mime_types = array['application/json'];

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('divya-yatra-photos', 'divya-yatra-photos', false, 8388608, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = false, file_size_limit = 8388608, allowed_mime_types = array['image/jpeg','image/png','image/webp'];

-- Users may only access objects whose first folder is their authenticated user UUID.
drop policy if exists "Divya users read own backup" on storage.objects;
create policy "Divya users read own backup" on storage.objects for select to authenticated
using (bucket_id = 'divya-yatra-backups' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Divya users upload own backup" on storage.objects;
create policy "Divya users upload own backup" on storage.objects for insert to authenticated
with check (bucket_id = 'divya-yatra-backups' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Divya users update own backup" on storage.objects;
create policy "Divya users update own backup" on storage.objects for update to authenticated
using (bucket_id = 'divya-yatra-backups' and (storage.foldername(name))[1] = (select auth.uid())::text)
with check (bucket_id = 'divya-yatra-backups' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Divya users delete own backup" on storage.objects;
create policy "Divya users delete own backup" on storage.objects for delete to authenticated
using (bucket_id = 'divya-yatra-backups' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Divya users read own photos" on storage.objects;
create policy "Divya users read own photos" on storage.objects for select to authenticated
using (bucket_id = 'divya-yatra-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Divya users upload own photos" on storage.objects;
create policy "Divya users upload own photos" on storage.objects for insert to authenticated
with check (bucket_id = 'divya-yatra-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Divya users update own photos" on storage.objects;
create policy "Divya users update own photos" on storage.objects for update to authenticated
using (bucket_id = 'divya-yatra-photos' and (storage.foldername(name))[1] = (select auth.uid())::text)
with check (bucket_id = 'divya-yatra-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Divya users delete own photos" on storage.objects;
create policy "Divya users delete own photos" on storage.objects for delete to authenticated
using (bucket_id = 'divya-yatra-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
