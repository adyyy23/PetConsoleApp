import React, { useState } from 'react';
import { Plus, Check, Clock, Trash2, Filter } from 'lucide-react';
import { Pet, Reminder } from '../types';

interface CareViewProps {
  pets: Pet[];
  reminders: Reminder[];
  onToggleReminder: (id: number) => void;
  onDeleteReminder: (id: number) => void;
  onOpenAddReminder: () => void;
}

export const CareView: React.FC<CareViewProps> = ({
  pets,
  reminders,
  onToggleReminder,
  onDeleteReminder,
  onOpenAddReminder
}) => {
  const [categoryFilter, setCategoryFilter] = useState<string>('All');
  const [petFilter, setPetFilter] = useState<number | 'All'>('All');

  const filteredReminders = reminders.filter(r => {
    const matchesCat = categoryFilter === 'All' || r.category === categoryFilter;
    const matchesPet = petFilter === 'All' || r.petId === petFilter;
    return matchesCat && matchesPet;
  });

  // Group by timeframe (Today, Tomorrow, Upcoming, Completed)
  const todayStr = '2026-10-02'; // Matching app's active reference date
  const tomorrowStr = '2026-10-03';

  const todayTasks = filteredReminders.filter(r => !r.completed && r.scheduleDate <= todayStr);
  const tomorrowTasks = filteredReminders.filter(r => !r.completed && r.scheduleDate === tomorrowStr);
  const upcomingTasks = filteredReminders.filter(r => !r.completed && r.scheduleDate > tomorrowStr);
  const completedTasks = filteredReminders.filter(r => r.completed);

  const categories = ['All', 'Medication', 'Feeding', 'Grooming', 'Vaccination', 'Exercise'];

  return (
    <div className="app-container">
      <div className="page-header">
        <div>
          <h1 className="page-title">Care Routines</h1>
          <p className="page-subtitle">
            Daily feeding, medications, exercise, and grooming agenda for your pets.
          </p>
        </div>

        <button className="btn btn-primary" onClick={onOpenAddReminder}>
          <Plus style={{ width: 16, height: 16 }} />
          <span>New Care Task</span>
        </button>
      </div>

      {/* Filter Row: Pet filter + Category filters */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 28 }}>
        {pets.length > 1 && (
          <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4 }}>
            <button
              className={`btn btn-sm ${petFilter === 'All' ? 'btn-primary' : 'btn-secondary'}`}
              onClick={() => setPetFilter('All')}
            >
              All Pets
            </button>
            {pets.map(p => (
              <button
                key={p.id}
                className={`btn btn-sm ${petFilter === p.id ? 'btn-primary' : 'btn-secondary'}`}
                onClick={() => setPetFilter(p.id)}
              >
                {p.name}
              </button>
            ))}
          </div>
        )}

        <div style={{ display: 'flex', gap: 8, overflowX: 'auto', paddingBottom: 4 }}>
          {categories.map(cat => (
            <button
              key={cat}
              className={`btn btn-sm ${categoryFilter === cat ? 'btn-secondary' : 'btn-subtle'}`}
              style={{
                border: categoryFilter === cat ? '1.5px solid var(--primary)' : '1px solid var(--border-color)',
                color: categoryFilter === cat ? 'var(--primary)' : 'var(--text-secondary)',
                fontWeight: categoryFilter === cat ? 700 : 500
              }}
              onClick={() => setCategoryFilter(cat)}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      {/* Agenda Timeline Layout */}
      <div style={{ maxWidth: 840 }}>
        {/* TODAY */}
        <div className="agenda-group">
          <div className="agenda-date-badge">
            <Clock style={{ width: 14, height: 14, color: 'var(--primary)' }} />
            <span>Today</span>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {todayTasks.map(task => {
              const pet = pets.find(p => p.id === task.petId);
              return (
                <div key={task.id} className="routine-item">
                  <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                    <button
                      className="routine-check-btn"
                      onClick={() => onToggleReminder(task.id)}
                      aria-label="Mark done"
                    />
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <span style={{ fontSize: '0.8125rem', fontWeight: 700, color: 'var(--primary)' }}>
                          {task.time}
                        </span>
                        <span style={{ fontSize: '0.9375rem', fontWeight: 700, color: 'var(--text-primary)' }}>
                          {task.suggestion}
                        </span>
                      </div>
                      <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>
                        {pet?.name} ({pet?.breed}) • {task.category}
                      </div>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <span className={`badge ${task.priority === 'High' ? 'badge-rose' : task.priority === 'Medium' ? 'badge-honey' : 'badge-subtle'}`}>
                      {task.priority}
                    </span>
                    <button
                      onClick={() => onDeleteReminder(task.id)}
                      style={{ color: 'var(--text-muted)', padding: 4 }}
                      title="Remove task"
                    >
                      <Trash2 style={{ width: 14, height: 14 }} />
                    </button>
                  </div>
                </div>
              );
            })}

            {todayTasks.length === 0 && (
              <div style={{ padding: '16px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)', color: 'var(--text-muted)', fontSize: '0.875rem' }}>
                No more tasks pending for today.
              </div>
            )}
          </div>
        </div>

        {/* TOMORROW */}
        <div className="agenda-group">
          <div className="agenda-date-badge">
            <Clock style={{ width: 14, height: 14, color: 'var(--accent-honey)' }} />
            <span>Tomorrow</span>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {tomorrowTasks.map(task => {
              const pet = pets.find(p => p.id === task.petId);
              return (
                <div key={task.id} className="routine-item">
                  <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                    <button
                      className="routine-check-btn"
                      onClick={() => onToggleReminder(task.id)}
                      aria-label="Mark done"
                    />
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                        <span style={{ fontSize: '0.8125rem', fontWeight: 700, color: 'var(--accent-honey)' }}>
                          {task.time}
                        </span>
                        <span style={{ fontSize: '0.9375rem', fontWeight: 700, color: 'var(--text-primary)' }}>
                          {task.suggestion}
                        </span>
                      </div>
                      <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>
                        {pet?.name} • {task.category}
                      </div>
                    </div>
                  </div>

                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <span className={`badge ${task.priority === 'High' ? 'badge-rose' : 'badge-honey'}`}>
                      {task.priority}
                    </span>
                    <button
                      onClick={() => onDeleteReminder(task.id)}
                      style={{ color: 'var(--text-muted)', padding: 4 }}
                      title="Remove task"
                    >
                      <Trash2 style={{ width: 14, height: 14 }} />
                    </button>
                  </div>
                </div>
              );
            })}

            {tomorrowTasks.length === 0 && (
              <div style={{ padding: '16px', borderRadius: 'var(--radius-md)', backgroundColor: 'var(--bg-subtle)', color: 'var(--text-muted)', fontSize: '0.875rem' }}>
                No specific routines scheduled for tomorrow.
              </div>
            )}
          </div>
        </div>

        {/* UPCOMING THIS WEEK */}
        {upcomingTasks.length > 0 && (
          <div className="agenda-group">
            <div className="agenda-date-badge">
              <Clock style={{ width: 14, height: 14, color: 'var(--text-muted)' }} />
              <span>Upcoming Later</span>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {upcomingTasks.map(task => {
                const pet = pets.find(p => p.id === task.petId);
                return (
                  <div key={task.id} className="routine-item">
                    <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
                      <button
                        className="routine-check-btn"
                        onClick={() => onToggleReminder(task.id)}
                        aria-label="Mark done"
                      />
                      <div>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                          <span style={{ fontSize: '0.8125rem', fontWeight: 600, color: 'var(--text-muted)' }}>
                            {task.scheduleDate} at {task.time}
                          </span>
                          <span style={{ fontSize: '0.9375rem', fontWeight: 700, color: 'var(--text-primary)' }}>
                            {task.suggestion}
                          </span>
                        </div>
                        <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)', marginTop: 2 }}>
                          {pet?.name} • {task.category}
                        </div>
                      </div>
                    </div>

                    <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                      <span className={`badge ${task.priority === 'High' ? 'badge-rose' : 'badge-subtle'}`}>
                        {task.priority}
                      </span>
                      <button
                        onClick={() => onDeleteReminder(task.id)}
                        style={{ color: 'var(--text-muted)', padding: 4 }}
                        title="Remove task"
                      >
                        <Trash2 style={{ width: 14, height: 14 }} />
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* COMPLETED ROUTINES (Quiet Archive) */}
        {completedTasks.length > 0 && (
          <div className="agenda-group" style={{ marginTop: 36 }}>
            <div className="agenda-date-badge">
              <Check style={{ width: 14, height: 14, color: 'var(--text-muted)' }} />
              <span>Completed Recently ({completedTasks.length})</span>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              {completedTasks.map(task => {
                const pet = pets.find(p => p.id === task.petId);
                return (
                  <div key={task.id} className="routine-item completed">
                    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                      <button
                        className="routine-check-btn checked"
                        onClick={() => onToggleReminder(task.id)}
                        aria-label="Uncheck"
                      >
                        <Check style={{ width: 14, height: 14 }} />
                      </button>
                      <div>
                        <div style={{ fontSize: '0.875rem', textDecoration: 'line-through', color: 'var(--text-muted)' }}>
                          {task.suggestion}
                        </div>
                        <div style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>
                          {pet?.name} • {task.category}
                        </div>
                      </div>
                    </div>

                    <button
                      onClick={() => onDeleteReminder(task.id)}
                      style={{ color: 'var(--text-muted)', padding: 4 }}
                      title="Remove task"
                    >
                      <Trash2 style={{ width: 14, height: 14 }} />
                    </button>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
