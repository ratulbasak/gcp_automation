const grid = document.getElementById('grid');
const statusEl = document.getElementById('status');
const btn = document.getElementById('refresh');

function row(k, v) {
  const wrap = document.createElement('div');
  wrap.className = 'row';
  const a = document.createElement('div');
  a.className = 'k';
  a.textContent = k;
  const b = document.createElement('div');
  b.className = 'v';
  b.textContent = v ?? '—';
  wrap.appendChild(a); wrap.appendChild(b);
  return wrap;
}

async function load() {
  btn.disabled = true;
  statusEl.textContent = 'Loading…';
  try {
    const res = await fetch('/api/info', { cache: 'no-store' });
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const data = await res.json();
    grid.replaceChildren(
      row('Hostname', data.hostname),
      row('Local IP', data.local_ip),
      row('Public IP', data.public_ip),
      row('Current time', data.current_time),
      row('User', data.user),
      row('Current directory', data.current_directory_name)
    );
    statusEl.textContent = 'Updated just now';
  } catch (e) {
    statusEl.textContent = 'Failed to load: ' + e.message;
  } finally {
    btn.disabled = false;
  }
}

btn.addEventListener('click', load);
load();
